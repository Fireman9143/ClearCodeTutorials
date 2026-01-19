extends Area2D

var projectile_direction: Vector2
var projectile_speed := 150

func setup(start_pos: Vector2, proj_dir: Vector2):
	position = start_pos	
	projectile_direction = proj_dir
	
func _process(delta: float) -> void:
	position += projectile_direction * projectile_speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("blobs"):
		body.hit(projectile_direction * -1)
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
