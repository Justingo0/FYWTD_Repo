extends Camera2D
class_name GameCamera

func camera_shake(magnitude:float, period:float):
	var initial_position = offset
	var elapsed_time:float = 0.0
	while elapsed_time < period:
		var random_offset = Vector2(randf_range(-magnitude, magnitude), randf_range(-magnitude, magnitude))
		offset = initial_position + random_offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame
		offset = initial_position
