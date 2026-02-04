extends CharacterBody2D

@export var dialog: Array[String]
@export var texture: Texture2D
@export var shop_type: Global.Shop
var dialog_index:int
var player: CharacterBody2D

signal open_shop(shop_type: Global.Shop)

func _ready() -> void:
	$Sprite2D.texture = texture
	
func _process(_delta: float) -> void:
	if player:
		if player.position.distance_to(position) > 30:
			$Dialogue.hide()
			dialog_index = 0
	
func interact(player_char: CharacterBody2D):
	player = player_char

	var raw_direction = (player.position - position).normalized()
	var dir = Vector2i(round(raw_direction.x), round(raw_direction.y))
	match dir:
		Vector2i(1, 0): $Sprite2D.frame_coords = Vector2i(0, 2)
		Vector2i(-1, 0): $Sprite2D.frame_coords = Vector2i(0, 1)
		Vector2i(0, -1): $Sprite2D.frame_coords = Vector2i(0, 3)
		_: $Sprite2D.frame_coords = Vector2i(0, 0)
		
	$Dialogue.show()
	if dialog_index < dialog.size():
		$Dialogue.set_text(dialog[dialog_index])
		dialog_index += 1
	else:
		$Dialogue.hide()
		dialog_index = 0
		open_shop.emit(shop_type)
