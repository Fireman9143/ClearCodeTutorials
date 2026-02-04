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
var current_state: Global.State
var current_tool: Global.Tools
var current_style: Global.Style
var current_style_index: int
var current_machine: Global.Machine
var current_machine_index: int

const player_skins = {
	Global.Style.BASIC: preload("res://graphics/characters/main_basic.png"),
	Global.Style.BASEBALL: preload("res://graphics/characters/main_blue.png"),
	Global.Style.COWBOY: preload("res://graphics/characters/main_cowboy.png"),
	Global.Style.ENGLISH: preload("res://graphics/characters/main_grey.png"),
	Global.Style.STRAW: preload("res://graphics/characters/main_straw.png"),
	Global.Style.BEANIE: preload("res://graphics/characters/main_red.png"),
}

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
signal day_change
signal build(current_machine: Global.Machine)
signal machine_change(current_machine: Global.Machine)
signal close_shop

func _physics_process(_delta: float) -> void:
	match current_state:
		Global.State.DEFAULT:
			if can_move:
				get_input()
			move()
			animation()
		Global.State.FISHING:
			get_fishing_input()
		Global.State.BUILDING:
			get_building_input()
			move()
			animation()
		Global.State.SHOP:
			get_shopping_input()
			
func move():
	player_direction = Input.get_vector("left", "right", "up", "down")
	if player_direction:
		player_last_direction = player_direction
		var ray_direction = int(player_direction.y) if not player_direction.x else 0
		$RayCast2D.target_position = Vector2(player_direction.x, ray_direction).normalized() * 20
		if $Sounds/WalkTimer.is_stopped():
			$Sounds/WalkTimer.timeout.emit()
			$Sounds/WalkTimer.start()
	else:
		$Sounds/WalkTimer.stop()
	velocity = player_direction * player_speed * int(can_move)
	move_and_slide()
		
func get_input():
	if Input.is_action_just_pressed("action"):
		if not $RayCast2D.get_collider():
			tool_state_machine.travel(tool_connect[current_tool])
			$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			can_move = false
			$Sounds/WalkSound.stop()
			$Sounds/WalkTimer.stop()
			if current_tool in [Global.Tools.HOE, Global.Tools.WATER, Global.Tools.FISH, Global.Tools.SEED, Global.Tools.SWORD]:
				await $AnimationTree.animation_finished
				tool_use.emit(current_tool, position + player_last_direction * tool_direction_offset + Vector2(0, tool_y_offset))
				if current_tool == Global.Tools.HOE:
					$Sounds/HoeSound.play()
				elif current_tool == Global.Tools.WATER:
					$Sounds/WaterSound.play()
				else:
					$Sounds/FishSound.play()
		else:
			$RayCast2D.get_collider().interact(self)
				
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
		$Sounds/WalkSound.stop()
		$Sounds/WalkTimer.stop()
		player_direction = Vector2.ZERO
		await $AnimationTree.animation_finished
		tool_use.emit(current_tool, position + player_last_direction * tool_direction_offset + Vector2(0, tool_y_offset))
		seed_use.emit(current_seed, position + player_last_direction * tool_direction_offset + Vector2(0, tool_y_offset))		
		await get_tree().create_timer(0.5).timeout
		can_move = true
	if Input.is_action_just_pressed("diagnose"):
		diagnose.emit()
	if Input.is_action_just_pressed("toggle_style"):
		current_style_index = posmod(current_style_index + 1, Global.unlocked_styles.size())
		current_style = Global.unlocked_styles[current_style_index] as Global.Style
		$Sprite2D.texture = player_skins[current_style]
	if Input.is_action_just_pressed("build"):
		current_state = Global.State.BUILDING
		current_machine =  Global.unlocked_machines[current_machine_index] as Global.Machine
		
func get_fishing_input():
	if Input.is_action_just_pressed("action"):
		$FishingGame.action()
		
func get_building_input():
	if Input.is_action_just_pressed("build"):
		current_state = Global.State.DEFAULT
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		var dir = Input.get_axis("tool_backward", "tool_forward")
		current_machine_index = posmod(current_machine_index + int(dir), Global.unlocked_machines.size())
		current_machine =  Global.unlocked_machines[current_machine_index] as Global.Machine
		machine_change.emit(current_machine)
	if Input.is_action_just_pressed("action"):
		build.emit(current_machine)
		
func get_shopping_input():
	if Input.is_action_just_pressed("ui_cancel"):
		close_shop.emit()
	
func animation():
	if player_direction:
		move_state_machine.travel("walk")
		var rounded_direction: Vector2 = Vector2(round(player_direction.x), round(player_direction.y))
		$AnimationTree.set("parameters/MoveeStateMachine/walk/blend_position", rounded_direction)
		$AnimationTree.set("parameters/MoveeStateMachine/idle/blend_position", rounded_direction)
		$AnimationTree.set("parameters/Fishing/blend_position", rounded_direction)
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

func day_change_emit():
	day_change.emit()

func start_fishing():
	$FishingGame.reveal()
	current_state = Global.State.FISHING
	$AnimationTree.set('parameters/FishBlend/blend_amount', 1)

func stop_fishing():
	can_move = true
	current_state = Global.State.DEFAULT
	$AnimationTree.set('parameters/FishBlend/blend_amount', 0)

func get_machine_coord() -> Vector2i:
	var pos = position + player_last_direction * 20 + Vector2(0, 8)
	var coord = Vector2i(pos.x / 16, pos.y / 16)
	coord.x -= 1 if pos.x < 0 else 0
	coord.y -= 1 if pos.y < 0 else 0
	return coord * 16 + Vector2i(8, 8)
