extends Button

var item_enum
var shop_type: Global.Shop
var unlocked: Array
signal press(shop_type)

func setup(new_shop_type, new_item_enum, parent):
	item_enum = new_item_enum
	shop_type = new_shop_type
	
	parent.add_child(self)
	var source = Global.STYLE_UPGRADES if shop_type == Global.Shop.HAT else Global.MACHINE_UPGRADE_COST
	var data = source[item_enum]
	unlocked = Global.unlocked_machines if shop_type == Global.Shop.MAIN else Global.unlocked_styles
	var item1 = Global.ITEM_IMAGES[data['cost'].keys()[0]]
	var item2 = Global.ITEM_IMAGES[data['cost'].keys()[1]]
	$VBoxContainer/ColorRect.color = data['color']
	$VBoxContainer/ColorRect/TextureRect.texture = data['icon']
	$VBoxContainer/VBoxContainer/Label.text = data['name']
	$VBoxContainer/VBoxContainer/Control/HBoxContainer/HBoxContainer/TextureRect.texture = item1
	$VBoxContainer/VBoxContainer/Control/HBoxContainer/HBoxContainer/Label.text = str(data['cost'].values()[0])
	$VBoxContainer/VBoxContainer/Control/HBoxContainer/HBoxContainer2/TextureRect.texture = item2
	$VBoxContainer/VBoxContainer/Control/HBoxContainer/HBoxContainer2/Label.text = str(data['cost'].values()[1])
	


func _on_focus_entered() -> void:
	$background.theme_type_variation = "FocusPanel"


func _on_focus_exited() -> void:
	$background.theme_type_variation = ""


func _on_pressed() -> void:
	unlocked.append(item_enum)
	press.emit(shop_type)
