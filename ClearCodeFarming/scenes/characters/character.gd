extends CharacterBody2D

var player: CharacterBody2D

func _process(_delta: float) -> void:
	if player:
		if player.position.distance_to(position) > 30:
			$Dialogue.hide()
	
	
func interact(player_char: CharacterBody2D):
	player = player_char

	var raw_direction = (player.position - position).normalized()
	var dir = Vector2i(round(raw_direction.x), round(raw_direction.y))
	match dir:
		Vector2i(1, 0): $Sprite2D.frame_coords = Vector2i(0, 2)
		Vector2i(-1, 0): $Sprite2D.frame_coords = Vector2i(0, 1)
		Vector2i(0, -1): $Sprite2D.frame_coords = Vector2i(0, 3)
		_: $Sprite2D.frame_coords = Vector2i(0, 0)
		
	$Dialogue.show()
