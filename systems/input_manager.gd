extends Node3D
class_name InputManager

@export var card_manager: CardManager
@export var player_hand: PlayerHand

signal left_mouse_button_clicked
signal left_mouse_button_released

const COLLISION_MASK_CARD: int = 1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")
			
func raycast_at_cursor() -> void:
	var viewport: Viewport = get_viewport()
	var camera: Camera3D = viewport.get_camera_3d()
	var mouse_position: Vector2 = viewport.get_mouse_position()
	if camera:
		var from: Vector3 = camera.project_ray_origin(mouse_position)
		var to: Vector3 = from + camera.project_ray_normal(mouse_position) * 1000 # might need to adjust?
		# Use the direct space state to perform the raycast
		var params: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
		params.collide_with_areas = true
		var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(params)
		if result:
			var result_collision_mask: int = result.collider.collision_mask
			if result_collision_mask == COLLISION_MASK_CARD:
				# Card clicked
				var card_found = result.collider.get_parent()
				if card_found and card_found in player_hand.cards:
					card_manager.start_drag(card_found)
