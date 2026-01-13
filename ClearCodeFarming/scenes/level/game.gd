extends Node2D

var plant_info_scene = preload("res://scenes/UI/plant_info.tscn")
@onready var player = $Objects/Player
@onready var blob_scene: PackedScene = preload("res://scenes/enemy/blob.tscn")
@onready var plant_scene: PackedScene = preload("res://scenes/level/plant.tscn")
#@onready var Bed_scene: PackedScene = preload("res://scenes/characters/bed.tscn")
@export var daytime_gradient: Gradient
@export var rain_color: Color
var raining: bool:
	set(value):
		raining = value
		$Layers/RainDropSplash.emitting = value
		$CanvasLayer/RainDropParticles.emitting = value
@export_range(0.0, 100.0, 1.0) var rain_chance_percent: float = randf_range(0.0, 100.0)
var randomf: float
var rain_chance: float
var used_cells: Array[Vector2i]
	
func _ready() -> void:
	check_mud()
	create_forcast()
	
func _process(_delta: float) -> void:
	var daytime_point: float = 1.0 - ($DayTimer.time_left / $DayTimer.wait_time)
	$CanvasModulate.color = daytime_gradient.sample(daytime_point).lerp(rain_color, 0.5 if raining else 0.0)
	if Input.is_action_just_pressed("ui_focus_next"):
		day_switch()
	var player_pos = player.position + player.player_last_direction * player.tool_direction_offset + Vector2(0, player.tool_y_offset)
	var grid_pos = Vector2i(int(player_pos.x / 16), int(player_pos.y / 16))
	grid_pos.x -= 1 if grid_pos.x < 0 else 0
	grid_pos.y -= 1 if grid_pos.y < 0 else 0
	$Layers/TargetingLayer.clear()
	$Layers/TargetingLayer.set_cell(grid_pos, 0, Vector2i(3, 1))
	
func _on_player_tool_use(tool: int, pos: Vector2) -> void:
	var grid_pos = Vector2i(int(pos.x / 16), int(pos.y / 16))
	grid_pos.x -= 1 if grid_pos.x < 0 else 0
	grid_pos.y -= 1 if grid_pos.y < 0 else 0
	var has_soil = $Layers/SoilLayer.get_cell_tile_data(grid_pos)
	match tool:
		Global.Tools.HOE:
			var cell = $Layers/GrassLayer.get_cell_tile_data(grid_pos) as TileData
			if cell and cell.get_custom_data("usable"):
				$Layers/SoilLayer.set_cells_terrain_connect([grid_pos], 0, 0)
				if raining:
					$Layers/SoilWaterLayer.set_cell(grid_pos, 1, Vector2i(randi_range(0,2), 0))
		Global.Tools.WATER:
			if has_soil:
				$Layers/SoilWaterLayer.set_cell(grid_pos, 1, Vector2i(randi_range(0,2), 0))
		Global.Tools.AXE:
			for tree in get_tree().get_nodes_in_group("Trees"):
				if tree.position.distance_to(pos) <10:
					tree.hit()
					tree.get_apple()
					tree.health -= 1
		Global.Tools.FISH:
			if not grid_pos in $Layers/GrassLayer.get_used_cells():
				$Objects/Player.start_fishing()
		Global.Tools.SWORD:
			for blob in get_tree().get_nodes_in_group("blobs"):
				if (player.position.distance_to(blob.position)) <= 20:
					blob.hit()
				
func _on_player_seed_use(seed_enum: int, pos: Vector2) -> void:
	var grid_pos = Vector2i(int(pos.x / 16), int(pos.y / 16))
	grid_pos.x -= 1 if grid_pos.x < 0 else 0
	grid_pos.y -= 1 if grid_pos.y < 0 else 0
	var cell = $Layers/SoilLayer.get_cell_tile_data(grid_pos) as TileData
	if cell and grid_pos not in used_cells:
		var plant_pos = Vector2(grid_pos.x * 16 + 8, grid_pos.y * 16 - 4)
		var plant = plant_scene.instantiate() as StaticBody2D
		plant.setup(seed_enum, grid_pos, plant_death)
		$Objects.add_child(plant)
		plant.position = plant_pos
		used_cells.append(grid_pos)
		var plant_info = plant_info_scene.instantiate()
		plant_info.setup(plant)
		$CanvasLayer/PlantInfoContainer.add(plant_info)
		
func _on_player_diagnose() -> void:
	$CanvasLayer/PlantInfoContainer.visible = not $CanvasLayer/PlantInfoContainer.visible

func day_switch():
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "modulate:a", 1.0, 0.5)
	tween.tween_callback(level_reset)
	tween.tween_interval(1.0)
	tween.tween_property($CanvasLayer/ColorRect, "modulate:a", 0.0, 0.5)
	
func level_reset():
	for plant in get_tree().get_nodes_in_group("Plants"):
		plant.grow(plant.grid_pos in $Layers/SoilWaterLayer.get_used_cells())
	$Layers/SoilWaterLayer.clear()
	for tree in get_tree().get_nodes_in_group("Trees"):
		tree.create_apples()
		tree.health = tree.number_of_apples + 1
	$DayTimer.start()
	$CanvasLayer/PlantInfoContainer.update_all()
	raining = Global.forecast_rain
	create_forcast()
	check_mud()

func _on_enemy_spawn_timer_timeout() -> void:
	var blob_count = get_tree().get_nodes_in_group("blobs")
	if blob_count.size() < 4:
		var blob = blob_scene.instantiate() as CharacterBody2D
		var spawn_points = $EnemyMarkers.get_children().pick_random() as Marker2D
		blob.position = spawn_points.position
		$Objects.add_child(blob)

func plant_death(coord: Vector2i):
	used_cells.erase(coord)

func create_forcast():
	#randomize()
	rain_chance_percent = randi_range(0, 100)
	rain_chance = rain_chance_percent/100
	Global.forecast_rain = true if rain_chance > 0.5 else false
	
func check_mud():
	if raining:
		for cell in $Layers/SoilLayer.get_used_cells():
			$Layers/SoilWaterLayer.set_cell(cell, 1, Vector2i(randi_range(0,2), 0))
	else:
		$Layers/SoilWaterLayer.clear()

func _on_player_day_change() -> void:
	day_switch()
