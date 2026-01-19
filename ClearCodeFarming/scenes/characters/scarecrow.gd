extends Machine

	
func get_closest_blob() -> CharacterBody2D:
	var blobs = get_tree().get_nodes_in_group("blobs")
	var nearest = blobs[3]
	for blob in blobs:
		if blob.postion.distance_to(position) <= nearest.position.distance_to(position):
			nearest = blob
	return nearest
			

func _on_timer_timeout() -> void:
	print(get_closest_blob())
