class_name InputHandler extends Node3D

@export var collision_system: CollisionSystem
@export var drag_drop_system: DragAndDropSystem

signal left_mouse_pressed
signal left_mouse_released
signal card_selected(card: Card)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			left_mouse_pressed.emit()
			_handle_card_selection()
		else:
			left_mouse_released.emit()
			drag_drop_system.finish_drag()

func _handle_card_selection() -> void:
	var card = collision_system.get_card_under_mouse()
	if card:
		card_selected.emit(card)
		drag_drop_system.start_drag(card)
