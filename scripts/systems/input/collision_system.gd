class_name CollisionSystem extends Node3D

@export var ray_distance: float = 1000.0

func get_card_under_mouse() -> Card:
	return _raycast(1) as Card  # 1 = COLLISION_MASK_CARD

func get_slot_under_mouse() -> CardSlot:
	return _raycast(2) as CardSlot  # 2 = COLLISION_MASK_CARD_SLOT

func _raycast(collision_mask: int) -> Node:
	var viewport = get_viewport()
	var camera = viewport.get_camera_3d()
	var mouse_pos = viewport.get_mouse_position()
	
	if !camera: return null
	
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_distance
	
	var params = PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to = to
	params.collide_with_areas = true
	params.collision_mask = collision_mask
	
	var result = get_world_3d().direct_space_state.intersect_ray(params)
	if result:
		var collider = result.get("collider")
		return collider.get_parent() if collider else null
		
	return null
