extends TextureRect

var item_type: Global.Item

func setup(new_item_type: Global.Item, new_texture: Texture2D):
	item_type = new_item_type
	texture = new_texture
	update()
	
func update():
	$Label.text = str(Global.items[item_type])
