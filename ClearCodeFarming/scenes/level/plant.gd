extends StaticBody2D

var grid_pos: Vector2i
var texture: Texture2D
var icon_texture: Texture2D
var plant_name: String
var age: float
var max_age: int
var grow_speed: float
var death_max: int
var reward: Global.Item
var death_count: int:
	set(value):
		death_count = value
		#emit_signal("dying")
var is_dead: bool:
	set(value):
		is_dead = value
		emit_signal("died")
signal death(grid_pos: Vector2i)
signal died(is_dead: bool)
#signal dying

const plant_data = {
	Global.Seeds.CORN: {
		"texture": preload("res://graphics/plants/corn.png"),
		"icon_texture": preload("res://graphics/icons/corn.png"),
		"plant_name": "Corn",
		"max_age": 3,
		"grow_speed": 1.0,
		"death_max": 3,
		"reward": Global.Item.CORN,
	},
	Global.Seeds.TOMATO: {
		"texture": preload("res://graphics/plants/tomatoes.png"),
		"icon_texture": preload("res://graphics/icons/tomato.png"),
		"plant_name": "Tomato",
		"max_age": 3,
		"grow_speed": 0.6,
		"death_max": 3,
		"reward": Global.Item.TOMATO,
	},
	Global.Seeds.PUMPKIN: {
		"texture": preload("res://graphics/plants/pumpkin.png"),
		"icon_texture": preload("res://graphics/icons/pumpkin.png"),
		"plant_name": "pumpkin",
		"max_age": 3,
		"grow_speed": 0.3,
		"death_max": 3,
		"reward": Global.Item.PUMPKIN,
	},
	Global.Seeds.WHEAT: {
		"texture": preload("res://graphics/plants/wheat.png"),
		"icon_texture": preload("res://graphics/icons/wheat.png"),
		"plant_name": "Wheat",
		"max_age": 3,
		"grow_speed": 1.0,
		"death_max": 3,
		"reward": Global.Item.WHEAT,
	},
}
func setup(seed_enum: Global.Seeds, grid_position: Vector2i, plant_death_function, reward_item: Global.Item):
	$Sprite2D.texture = plant_data[seed_enum]['texture']
	icon_texture = plant_data[seed_enum]['icon_texture']
	plant_name = plant_data[seed_enum]['plant_name']
	max_age = plant_data[seed_enum]['max_age']
	grow_speed = plant_data[seed_enum]['grow_speed']
	death_max = plant_data[seed_enum]['death_max']
	reward = reward_item
	grid_pos = grid_position
	death.connect(plant_death_function)
	#dying.connect(update)
	
func update():
	if death_count >= death_max:
		is_dead = true
		death.emit(grid_pos)
		queue_free()
		
func grow(watered: bool):
	if watered:
		age = min(age + grow_speed, max_age)
		$Sprite2D.frame = int(age)
		death_count = 0
	else:
		death_count += 1
		if death_count == death_max and age != max_age:
			queue_free()
			is_dead = true
			death.emit(grid_pos)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if age >= max_age:
		Global.change_item(reward, randi_range(2, 4))
		is_dead = true
		death.emit(grid_pos)
		#dying.emit()
		queue_free()
		
func damage():
	death_count += 1
