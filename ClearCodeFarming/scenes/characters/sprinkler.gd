extends Machine




func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play("action")
	$GPUParticles2D.emitting = true
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("default")
	
