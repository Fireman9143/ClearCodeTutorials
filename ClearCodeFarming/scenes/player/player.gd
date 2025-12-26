extends CharacterBody2D

#var ToolUI_scene = preload("res://scenes/UI/tool_ui.tscn")

var player_direction: Vector2
var player_last_direction: Vector2
var player_speed: int = 70
@export var tool_direction_offset := 14
@export var tool_y_offset := 4
@onready var move_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/MoveeStateMachine/playback")
@onready var tool_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/ToolStateMachine/playback")
var can_move: bool = true


var current_tool: Global.Tools = Global.Tools.SWORD
const tool_connect = {
	Global.Tools.HOE: "hoe",
	Global.Tools.AXE: "axe",
	Global.Tools.WATER: "water",
	Global.Tools.FISH: "fish",
	Global.Tools.SEED: "seed",
	Global.Tools.SWORD: "sword",
}
signal tool_use(tool: Global.Tools, pos: Vector2)

var current_seed: Global.Seeds = Global.Seeds.CORN
signal seed_use(seed: Global.Seeds, pos: Vector2)

signal diagnose

func _physics_process(_delta: float) -> void:
	if can_move:
		get_input()
	if player_direction:
		player_last_direction = player_direction
		if $Sounds/WalkTimer.is_stopped():
			$Sounds/WalkTimer.timeout.emit()
			$Sounds/WalkTimer.start()
	else:
		$Sounds/WalkTimer.stop()
	velocity = player_direction * player_speed * int(can_move)
	move_and_slide()
	animation()
	
func get_input():
	player_direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("action"):
		tool_state_machine.travel(tool_connect[current_tool])
		$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		can_move = false
		if current_tool in [Global.Tools.HOE, Global.Tools.WATER, Global.Tools.FISH, Global.Tools.SEED, Global.Tools.SWORD]:
			await $AnimationTree.animation_finished
			tool_use.emit(current_tool, position + player_last_direction * tool_direction_offset + Vector2(0, tool_y_offset))
			if current_tool == Global.Tools.HOE:
				$Sounds/HoeSound.play()
			elif current_tool == Global.Tools.WATER:
				$Sounds/WaterSound.play()
			else:
				$Sounds/FishSound.play()
				
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		var dir = Input.get_axis("tool_backward", "tool_forward")
		current_tool = posmod(current_tool + int(dir), Global.Tools.size()) as Global.Tools
		$ToolUI.reveal("tool")
	if Input.is_action_just_pressed("seed_toggle"):
		current_seed = posmod(current_seed + 1, Global.Seeds.size()) as Global.Seeds
		$ToolUI.reveal("seed")
	if Input.is_action_just_pressed("plant") and current_tool == Global.Tools.SEED:
		tool_state_machine.travel(tool_connect[current_tool])
		$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		can_move = false
		player_direction = Vector2.ZERO
		await $AnimationTree.animation_finished
		tool_use.emit(current_tool, position + player_last_direction * tool_direction_offset + Vector2(0, tool_y_offset))
		seed_use.emit(current_seed, position + player_last_direction * tool_direction_offset + Vector2(0, tool_y_offset))		
		await get_tree().create_timer(0.5).timeout
		can_move = true
	if Input.is_action_just_pressed("diagnose"):
		diagnose.emit()
func animation():
	if player_direction:
		move_state_machine.travel("walk")
		var rounded_direction: Vector2 = Vector2(round(player_direction.x), round(player_direction.y))
		$AnimationTree.set("parameters/MoveeStateMachine/walk/blend_position", rounded_direction)
		$AnimationTree.set("parameters/MoveeStateMachine/idle/blend_position", rounded_direction)
		for state in tool_connect.values():
			$AnimationTree.set("parameters/ToolStateMachine/" + state + "/blend_position", rounded_direction)
	else:
		move_state_machine.travel("idle")
		
func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	can_move = true
	
func axe_use():
	tool_use.emit(current_tool, position + player_last_direction * tool_direction_offset + Vector2(0, tool_y_offset))

func _on_walk_timer_timeout() -> void:
	$Sounds/WalkSound.play()
