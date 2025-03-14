class_name PlayerHand extends BaseHand

const FAN_ANGLE := 30.0
const CARD_Z_OFFSET := 0.05
const Z_SPACING := 0.01
const SCREEN_MARGIN_BOTTOM := 0.2
const HAND_DISTANCE_FROM_CAMERA := 3.2
const VERTICAL_ARC_HEIGHT := 2.0
const MIN_RADIUS := 1.0
const MAX_RADIUS := 3.0
const MIN_CARDS_FOR_GROWTH := 2
const MAX_CARDS_FOR_GROWTH := 10

@export var turn_system: TurnSystem

var viewport_center_bottom: Vector2:
	get: return _get_viewport_center_bottom()

func _ready() -> void:
	super._ready()
	turn_system.phase_changed.connect(_on_phase_changed)
	
func _on_phase_changed(new_phase: TurnSystem.Phase) -> void:
	_update_card_playability()

func update_hand_base_position() -> void:
	if !camera:
		return
	
	var ray_origin = camera.project_ray_origin(viewport_center_bottom)
	var ray_dir = camera.project_ray_normal(viewport_center_bottom)
	hand_base_position = ray_origin + ray_dir * HAND_DISTANCE_FROM_CAMERA
	hand_base_position += camera.global_transform.basis.y * -0.5

func update_hand_positions() -> void:
	_update_card_playability()
	var card_count = cards.size()
	var current_radius = _calculate_dynamic_radius(card_count)
	var camera_right = camera.global_transform.basis.x
	var camera_up = camera.global_transform.basis.y

	for i in card_count:
		var card = cards[i]
		var t = float(i) / (card_count - 1) if card_count > 1 else 0.5
		var angle = lerp(-FAN_ANGLE/2, FAN_ANGLE/2, t)
		var radian_angle = deg_to_rad(angle)

		var horizontal_offset = sin(radian_angle) * current_radius
		var vertical_offset = (cos(radian_angle) - 1) * VERTICAL_ARC_HEIGHT
		
		var camera_space_offset = (
			camera_right * horizontal_offset +
			camera_up * vertical_offset
		)
		
		var target_position = hand_base_position + camera_space_offset
		target_position.z = hand_base_position.z + (i * Z_SPACING)
		
		_animate_card(card, target_position, Vector3(0, 180, angle), i)

func _get_viewport_center_bottom() -> Vector2:
	var viewport = get_viewport()
	if viewport:
		var size = viewport.get_visible_rect().size
		return Vector2(size.x * 0.5, size.y * (1.0 - SCREEN_MARGIN_BOTTOM))
	return Vector2.ZERO

func _calculate_dynamic_radius(card_count: int) -> float:
	if card_count <= MIN_CARDS_FOR_GROWTH:
		return MIN_RADIUS
	if card_count >= MAX_CARDS_FOR_GROWTH:
		return MAX_RADIUS
	
	var t = float(card_count - MIN_CARDS_FOR_GROWTH) / float(MAX_CARDS_FOR_GROWTH - MIN_CARDS_FOR_GROWTH)
	return lerp(MIN_RADIUS, MAX_RADIUS, t)

func _animate_card(card: Card, target_position: Vector3, target_rotation: Vector3, index: int) -> void:
	card.target_rotation = target_rotation
	card.hand_position = target_position
	card.update_render_priority(index)
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(card, "global_position", target_position, 0.15)
	tween.tween_property(card, "rotation_degrees", target_rotation, 0.15)

func _update_card_playability() -> void:
	for card in cards:
		card.check_playability(GameManager.player_data)
