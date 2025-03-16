class_name DragAndDropSystem extends Node3D

@export var camera: Camera3D
@export var collision_system: CollisionSystem
@export var screen_margin: int = 50

var drag_plane_normal: Vector3
var drag_plane_point: Vector3
var dragged_card: Card

func _process(_delta: float) -> void:
	if dragged_card:
		update_dragged_position()

func start_drag(card: Card) -> void:
	dragged_card = card
	_calculate_drag_plane(card.view.position)
	dragged_card.view.start_drag()

func _calculate_drag_plane(card_position: Vector3) -> void:
	if camera:
		drag_plane_normal = camera.global_transform.basis.z.normalized()
		drag_plane_point = card_position

func update_dragged_position() -> void:
	if !dragged_card || !camera: return
	
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)
	
	var denom = ray_dir.dot(drag_plane_normal)
	if abs(denom) < 1e-6: return
	
	var t = (drag_plane_point - ray_origin).dot(drag_plane_normal) / denom
	if t < 0: return
	
	var target_pos = ray_origin + ray_dir * t
	dragged_card.view.position = _clamp_position_to_screen(target_pos)

func _clamp_position_to_screen(world_pos: Vector3) -> Vector3:
	var viewport = get_viewport()
	var screen_pos = camera.unproject_position(world_pos)
	var viewport_rect = viewport.get_visible_rect()
	
	screen_pos.x = clamp(screen_pos.x, viewport_rect.position.x + screen_margin, viewport_rect.end.x - screen_margin)
	screen_pos.y = clamp(screen_pos.y, viewport_rect.position.y + screen_margin, viewport_rect.end.y - screen_margin)
	
	return camera.project_position(screen_pos, camera.global_transform.origin.distance_to(world_pos))

func finish_drag() -> void:
	if !dragged_card: return
	
	var slot = collision_system.get_slot_under_mouse()
	if slot && slot.accepts_card_type(dragged_card):
		slot.add_card(dragged_card)
		EventBus.card_played.emit(dragged_card)
	else:
		_return_card_to_hand()
	
	dragged_card.view.end_drag()
	dragged_card = null
	CardHoverSystem.should_hover = true
	
func _return_card_to_hand() -> void:
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(dragged_card.view, "position", dragged_card.view.hand_position, 0.15)
	tween.tween_property(dragged_card.view, "rotation_degrees", dragged_card.view.target_rotation, 0.15)
	tween.tween_property(dragged_card.view, "scale", Vector3(0.5, 0.5, 0.5), 0.15)
