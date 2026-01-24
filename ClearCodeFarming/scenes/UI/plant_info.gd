extends PanelContainer

var plant

func setup(source):
	plant = source
	$HBoxContainer/IconTexture.texture = plant.icon_texture
	$HBoxContainer/VBoxContainer/Label.text = plant.plant_name
	$HBoxContainer/VBoxContainer/GrowthBar.max_value = plant.max_age
	$HBoxContainer/VBoxContainer/GrowthBar.max_value = plant.death_max
	update()
	plant.died.connect(update)
	
func update():
	$HBoxContainer/VBoxContainer/GrowthBar.value = plant.age
	$HBoxContainer/VBoxContainer/DeathBar.value = plant.death_count
	if plant.death_count >= plant.death_max:
		queue_free()
