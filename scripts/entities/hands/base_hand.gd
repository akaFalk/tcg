class_name BaseHand extends Node3D

signal card_added(card: Card)
signal card_removed(card: Card)

@export var config: HandConfig
@export var camera: Camera3D
@export var turn_system: TurnSystem
@export var deck: Deck

var cards: Array[Card] = []
var hand_base_position: Vector3

func _ready() -> void:
	assert(config != null, "HandConfig must be assigned")
	if !camera:
		camera = get_viewport().get_camera_3d()
	get_viewport().connect("size_changed", update_hand_base_position)
	update_hand_base_position()
	deck.connect("card_drawn", _on_card_drawn)

	if turn_system:
		turn_system.phase_changed.connect(_on_phase_changed)

func update_hand_base_position() -> void:
	if !camera:
		return
	
	var viewport_pos = _get_viewport_margin_position()
	var ray_origin = camera.project_ray_origin(viewport_pos)
	var ray_dir = camera.project_ray_normal(viewport_pos)
	
	hand_base_position = ray_origin + ray_dir * config.hand_distance_from_camera
	hand_base_position += camera.global_transform.basis.y * config.vertical_offset

func update_hand_positions() -> void:
	_on_hand_updated()
	var card_count = cards.size()
	var current_radius = _calculate_dynamic_radius(card_count)
	
	for i in card_count:
		var card = cards[i]
		var t = float(i) / (card_count - 1) if card_count > 1 else 0.5
		var angle = lerp(-config.fan_angle/2, config.fan_angle/2, t)
		var radian_angle = deg_to_rad(angle)
		
		# Use overridden methods
		var vertical_offset = _calculate_vertical_offset(radian_angle)
		var horizontal_offset = sin(radian_angle) * current_radius
		
		var camera_right = camera.global_transform.basis.x
		var camera_up = camera.global_transform.basis.y
		
		var camera_space_offset = (
			camera_right * horizontal_offset +
			camera_up * vertical_offset
		)
		
		var target_position = hand_base_position + camera_space_offset
		target_position.z = _calculate_z_position(hand_base_position.z, i)
		
		var target_rotation = _calculate_target_rotation(angle)
		
		_animate_card(card, target_position, target_rotation, i)
		
func _on_card_drawn(card: Card) -> void:
	_add_card(card)

func _add_card(card: Card) -> void:
	cards.append(card)
	card_added.emit(card)
	_configure_card(card)
	update_hand_positions()

func _remove_card_from_hand(card: Card) -> void:
	if card in cards:
		cards.erase(card)
		card_removed.emit(card)
		update_hand_positions()

func _configure_card(card: Card) -> void:
	card.scale = config.card_scale
	card._ui.set_labels_visible(config.show_labels)
	card.rotation_degrees.y = config.face_rotation_y

func _calculate_dynamic_radius(card_count: int) -> float:
	if card_count <= config.min_cards_for_growth:
		return config.min_radius
	if card_count >= config.max_cards_for_growth:
		return config.max_radius
	
	var t = float(
		card_count - config.min_cards_for_growth
	) / float(
		config.max_cards_for_growth - config.min_cards_for_growth
	)
	return lerp(config.min_radius, config.max_radius, t)

func _animate_card(card: Card, target_position: Vector3, target_rotation: Vector3, index: int) -> void:
	card.target_rotation = target_rotation
	card.hand_position = target_position
	card.update_render_priority(index)
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(card, "global_position", target_position, 0.15)
	tween.tween_property(card, "rotation_degrees", target_rotation, 0.15)


# Abstract methods to be implemented in subclasses
func _get_viewport_margin_position() -> Vector2:
	return Vector2.ZERO

func _on_phase_changed(new_phase: TurnSystem.Phase) -> void:
	pass
	
func _on_hand_updated() -> void:
	pass

func _calculate_vertical_offset(radian_angle: float) -> float:
	# Default implementation (can be abstract)
	assert(false, "Must be overridden in child classes")
	return 0.0

func _calculate_z_position(base_z: float, index: int) -> float:
	# Default implementation
	assert(false, "Must be overridden in child classes")
	return 0.0

func _calculate_target_rotation(angle: float) -> Vector3:
	# Default implementation
	assert(false, "Must be overridden in child classes")
	return Vector3.ZERO
