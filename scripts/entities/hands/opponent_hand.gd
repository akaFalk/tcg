class_name OpponentHand extends BaseHand


func _calculate_vertical_offset(radian_angle: float) -> float:
	return (1 - cos(radian_angle)) * config.vertical_arc_height

func _calculate_z_position(base_z: float, index: int) -> float:
	return base_z - (index * config.z_spacing)

func _calculate_target_rotation(angle: float) -> Vector3:
	return Vector3(0, 0, angle)

func _get_viewport_margin_position() -> Vector2:
	var viewport = get_viewport()
	if viewport:
		var size = viewport.get_visible_rect().size
		return Vector2(size.x * 0.5, size.y * config.screen_margin)
	return Vector2.ZERO
