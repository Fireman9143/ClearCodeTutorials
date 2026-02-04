extends Machine

signal shoot(start_pos: Vector2, proj_direction: Vector2)
@export var max_range := 150

func get_closest_blob(blobs: Array) -> CharacterBody2D:
	var nearest = blobs[0]
	for blob in blobs:
		if blob.position.distance_to(position) <= nearest.position.distance_to(position):
			nearest = blob
	return nearest
			

func _on_timer_timeout() -> void:
	var blobs = get_tree().get_nodes_in_group("blobs")
	if blobs:
		var nearest_blob = get_closest_blob(blobs)
		if nearest_blob.position.distance_to(position) <= max_range:
			shoot.emit(position, (nearest_blob.position - position).normalized())
