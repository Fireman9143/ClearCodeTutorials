extends CharacterBody2D

var player: CharacterBody2D

var blob_direction: Vector2
var blob_speed: int = 40
var blob_health := 5:
	set(value):
		blob_health = value
		if blob_health <= 0:
			explode()

@onready var blob_state: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/BlobMoveStateMachine/playback")

func _physics_process(_delta: float) -> void:
	if player and player.position.distance_to(position) > 20:
		blob_direction = (player.position - position).normalized()
		velocity = blob_direction * blob_speed
		move_and_slide()
		animation()
	
func animation():
	if player:
		blob_state.travel("move")
		var rounded_direction: Vector2 = Vector2(round(blob_direction.x), round(blob_direction.y))
		$AnimationTree.set("parameters/BlobMoveStateMachine/move/blend_position", rounded_direction)
		$AnimationTree.set("parameters/BlobMoveStateMachine/idle/blend_position", rounded_direction)
		$AnimationTree.set("parameters/BlobMoveStateMachine/explode/blend_position", rounded_direction)
	else:
		blob_state.travel("idle")

func _on_detection_area_body_entered(player_body: Node2D) -> void:
	player = player_body

func _on_detection_area_body_exited(_body: Node2D) -> void:
	player = null
	
func hit():
	blob_health -= 1
	var hit_tween = create_tween()
	hit_tween.tween_property($Sprite2D.material, "shader_parameter/progress", 1.0, 0.1)
	hit_tween.tween_property($Sprite2D.material, "shader_parameter/progress", 0.0, 0.1)
	
func explode():
	blob_speed = 0
	blob_state.travel("explode")
	await $AnimationPlayer.animation_finished
