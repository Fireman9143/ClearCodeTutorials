extends PanelContainer

var plant

func setup(source):
	plant = source
	$HBoxContainer/IconTexture.texture = plant.icon_texture
	$HBoxContainer/VBoxContainer/Label.text = plant.plant_name
	$HBoxContainer/VBoxContainer/GrowthBar.max_value = plant.max_age
	$HBoxContainer/VBoxContainer/GrowthBar.max_value = plant.death_max
	update()
	
	
func update():
	plant.died.connect(death_check)
	$HBoxContainer/VBoxContainer/GrowthBar.value = plant.age
	$HBoxContainer/VBoxContainer/DeathBar.value = plant.death_count

func death_check():
	queue_free()
