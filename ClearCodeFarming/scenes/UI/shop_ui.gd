extends Control

var shop_button_scene = preload("res://scenes/UI/shop_button.tscn")
signal close

func reveal(shop_type: Global.Shop = Global.Shop.HAT):
	show()
	for child in $GridContainer.get_children():
		child.queue_free()
		
	var unlocked = Global.shop_connection[shop_type]['tracker']
	var all = Global.shop_connection[shop_type]['all']
	var available = (unlocked + all).filter(func(x): return not(x in all and x in unlocked))
	if available:
		for item_enum in available:
			var shop_button = shop_button_scene.instantiate()
			shop_button.setup(shop_type, item_enum, $GridContainer)
			shop_button.connect('press', reveal)
		await get_tree().process_frame
		$GridContainer.get_child(0).grab_focus()
	else:
		close.emit()
		
