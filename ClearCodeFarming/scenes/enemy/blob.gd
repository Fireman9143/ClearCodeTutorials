extends CharacterBody2D

var player: CharacterBody2D #= get_tree().get_first_node_in_group("player")
var push_distance := 75
var push_direction: Vector2
var blob_direction: Vector2
var blob_speed: int = 40
var blob_health := 5:
	set(value):
		blob_health = value
		if blob_health <= 0:
			explode()
var plant_target: StaticBody2D
var active: bool = true

@onready var blob_state: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/BlobMoveStateMachine/playback")

func setup(start_pos, target, parent):
	position = start_pos
	parent.add_child(self)
	plant_target = target
	
func _physics_process(_delta: float) -> void:
	if plant_target:
		blob_direction = (plant_target.position - position).normalized()
		velocity = blob_direction * blob_speed + push_direction
		move_and_slide()
		animation()
		if position.distance_to(plant_target.position) < 10 and active:
			plant_target.damage()
			active = false
			explode()
	else:
		explode()
	
func animation():
	if player:
		blob_state.travel("move")
		var rounded_direction: Vector2 = Vector2(round(blob_direction.x), round(blob_direction.y))
		$AnimationTree.set("parameters/BlobMoveStateMachine/move/blend_position", rounded_direction)
		$AnimationTree.set("parameters/BlobMoveStateMachine/idle/blend_position", rounded_direction)
		$AnimationTree.set("parameters/BlobMoveStateMachine/explode/blend_position", rounded_direction)
	else:
		blob_state.travel("idle")
	
func hit(dir:Vector2 = Vector2.ZERO):
	push(dir)
	blob_health -= 1
	var hit_tween = create_tween()
	hit_tween.tween_property($Sprite2D.material, "shader_parameter/progress", 1.0, 0.1)
	hit_tween.tween_property($Sprite2D.material, "shader_parameter/progress", 0.0, 0.1)
	
func push(dir = Vector2.ZERO):
	var tween = get_tree().create_tween()
	var target_dir = dir if dir else (player.position - position).normalized() 
	var target = target_dir * -1 * push_distance
	tween.tween_property(self, "push_direction", target, 1)
	tween.tween_property(self, "push_direction", Vector2.ZERO, 0.2)

func explode():
	blob_speed = 0
	blob_state.travel("explode")
	await $AnimationPlayer.animation_finished
