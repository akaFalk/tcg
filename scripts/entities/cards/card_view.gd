class_name CardView extends Node3D

# Visual Components
@export var _ui: CardUI
@export var _collision_shape: CollisionShape3D

# Signals for input
signal hovered(card_view: CardView)
signal hovered_off(card_view: CardView)
signal drag_started
signal drag_ended

# Visual State
var hand_render_priority: int = 0
var target_rotation: Vector3
var hand_position: Vector3

func initialize_view(data: CardData) -> void:
	_ui.update_appearance(data)
	_ui.set_labels_visible(false)
	set_interactable(false)
	
func show_labels(display: bool) -> void:
	_ui.set_labels_visible(display)

func update_playable_visuals(is_playable: bool) -> void:
	_ui.set_playable_visuals(is_playable)

func animate_hover(active: bool) -> void:
	_ui.animate_hover(active)

func set_interactable(value: bool) -> void:
	_collision_shape.disabled = !value

func set_render_priority(priority: int) -> void:
	hand_render_priority = priority * 2
	_ui.set_render_priority(hand_render_priority)

# Input Handlers set through inspector node
func _on_area_3d_mouse_entered() -> void:
	hovered.emit(self)

func _on_area_3d_mouse_exited() -> void:
	hovered_off.emit(self)

func start_drag() -> void:
	drag_started.emit()
	_ui.set_render_priority(100)
	rotation_degrees.z = 0

func end_drag() -> void:
	drag_ended.emit()
	_ui.set_render_priority(hand_render_priority)
