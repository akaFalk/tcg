class_name OpponentHand extends BaseHand

const FAN_ANGLE := 30.0
const CARD_Z_OFFSET := 0.05
const Z_SPACING := 0.01
const SCREEN_MARGIN_TOP := 0.15  # Mirror of player's bottom margin
const HAND_DISTANCE_FROM_CAMERA := 3.2
const VERTICAL_ARC_HEIGHT := 2.0
const MIN_RADIUS := 1.0
const MAX_RADIUS := 3.0
const MIN_CARDS_FOR_GROWTH := 2
const MAX_CARDS_FOR_GROWTH := 10

var viewport_center_top: Vector2:
	get: return _get_viewport_center_top()

func update_hand_base_position() -> void:
	if !camera:
		return
	
	# Mirror the player hand's projection but from top of screen
	var ray_origin = camera.project_ray_origin(viewport_center_top)
	var ray_dir = camera.project_ray_normal(viewport_center_top)
	hand_base_position = ray_origin + ray_dir * HAND_DISTANCE_FROM_CAMERA
	
	# Flip the vertical offset direction
	hand_base_position += camera.global_transform.basis.y * 0.5

func update_hand_positions() -> void:
	var card_count = cards.size()
	var current_radius = _calculate_dynamic_radius(card_count)
	var camera_right = camera.global_transform.basis.x
	var camera_up = camera.global_transform.basis.y

	for i in card_count:
		var card = cards[i]
		var t = float(i) / (card_count - 1) if card_count > 1 else 0.5
		
		# Mirror the fan angle
		var angle = lerp(FAN_ANGLE/2, -FAN_ANGLE/2, t)
		var radian_angle = deg_to_rad(angle)
		
		# Invert vertical offset for downward arc
		var horizontal_offset = sin(radian_angle) * current_radius
		var vertical_offset = (1 - cos(radian_angle)) * VERTICAL_ARC_HEIGHT
		
		var camera_space_offset = (
			camera_right * horizontal_offset +
			camera_up * vertical_offset
		)
		
		# Invert Z ordering for proper stacking
		var target_position = hand_base_position + camera_space_offset
		target_position.z = hand_base_position.z - (i * Z_SPACING)
		
		# Mirror rotation
		var target_rotation = Vector3(0, 0, angle)
		_animate_card(card, target_position, target_rotation, i)

func _get_viewport_center_top() -> Vector2:
	var viewport = get_viewport()
	if viewport:
		var size = viewport.get_visible_rect().size
		return Vector2(size.x * 0.5, size.y * SCREEN_MARGIN_TOP)
	return Vector2.ZERO

func _calculate_dynamic_radius(card_count: int) -> float:
	# Same calculation as player hand
	if card_count <= MIN_CARDS_FOR_GROWTH:
		return MIN_RADIUS
	if card_count >= MAX_CARDS_FOR_GROWTH:
		return MAX_RADIUS
	
	var t = float(card_count - MIN_CARDS_FOR_GROWTH) / float(MAX_CARDS_FOR_GROWTH - MIN_CARDS_FOR_GROWTH)
	return lerp(MIN_RADIUS, MAX_RADIUS, t)

func _configure_card(card: Card) -> void:
	super._configure_card(card)
	card.set_labels_visible(false)  # Keep opponent's cards face-down
	card.rotation_degrees.y = 180  # Flip cards to face away

func _animate_card(card: Card, target_position: Vector3, target_rotation: Vector3, index: int) -> void:
	card.target_rotation = target_rotation
	card.hand_position = target_position
	card.update_render_priority(index)
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(card, "global_position", target_position, 0.15)
	tween.tween_property(card, "rotation_degrees", target_rotation, 0.15)
