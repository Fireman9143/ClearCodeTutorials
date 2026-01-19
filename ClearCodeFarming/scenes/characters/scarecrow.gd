extends Machine

signal shoot(start_pos: Vector2, proj_direction: Vector2)

func get_closest_blob(blobs: Array) -> CharacterBody2D:
	var nearest = blobs[0]
	for blob in blobs:
		if blob.position.distance_to(position) <= nearest.position.distance_to(position):
			nearest = blob
	return nearest
			

func _on_timer_timeout() -> void:
	var blobs = get_tree().get_nodes_in_group("blobs")
	if blobs:
		shoot.emit(position, (get_closest_blob(blobs).position - position).normalized())
