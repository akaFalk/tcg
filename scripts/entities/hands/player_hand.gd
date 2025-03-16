class_name PlayerHand extends BaseHand

@export var resource_component: ResourceComponent

func _ready():
	super._ready()
	EventBus.card_played.connect(_on_card_played)
	resource_component.resources_changed.connect(_on_resources_changed)
	
func _on_card_played(card: Card) -> void:
	if card in cards:
		_remove_card_from_hand(card)
		
func _on_card_drawn(card: Card) -> void:
	super._on_card_drawn(card)
	card.view.set_interactable(true)

func _calculate_vertical_offset(radian_angle: float) -> float:
	return (cos(radian_angle) - 1) * config.vertical_arc_height

func _calculate_z_position(base_z: float, index: int) -> float:
	return base_z + (index * config.z_spacing)

func _calculate_target_rotation(angle: float) -> Vector3:
	return Vector3(0, 180, angle)

func _get_viewport_margin_position() -> Vector2:
	var viewport = get_viewport()
	if viewport:
		var size = viewport.get_visible_rect().size
		return Vector2(size.x * 0.5, size.y * (1.0 - config.screen_margin))
	return Vector2.ZERO

func _on_phase_changed(_new_phase: TurnSystem.Phase) -> void:
	_update_card_playability()
	
func _on_hand_updated() -> void:
	_update_card_playability()

func _on_resources_changed(_current_resources: int, _max_resources: int) -> void:
	_update_card_playability()

func _update_card_playability() -> void:
	for card in cards:
		card.check_playability()
