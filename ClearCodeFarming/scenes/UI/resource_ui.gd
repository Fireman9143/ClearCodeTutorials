extends Control

var resource_texture_scene = preload("res://scenes/UI/resource_texture.tscn")

func _ready() -> void:
	for i: Global.Item in Global.items.keys():
		var resource_texture = resource_texture_scene.instantiate()
		resource_texture.setup(i, Global.ITEM_IMAGES[i])
		$HBoxContainer.add_child(resource_texture)

func reveal():
	for i in $HBoxContainer.get_children():
		i.update()
