extends StaticBody2D

const apple_texture = preload("res://graphics/plants/apple.png")
var number_of_apples := 3
var health := number_of_apples + 1:
	set(value):
		health = value
		if health <= 0:
				$TreeSprite.hide()
				$StumpSprite.show()
				var shape = RectangleShape2D.new()
				shape.size = Vector2(12, 6)
				$CollisionShape2D.shape = shape
				$CollisionShape2D.position.y = 6
				for apple in $Apples.get_children():
					apple.queue_free()
				Global.change_item(Global.Item.WOOD, randi_range(2, 4))
				
func _ready() -> void:
	$TreeSprite.frame = [0, 1].pick_random()
	if $TreeSprite.frame == 1:
		create_apples(3)
	
func hit():
	var tween = create_tween()
	tween.tween_property($TreeSprite.material, "shader_parameter/progress", 1.0, 0.2)
	tween.tween_property($TreeSprite.material, "shader_parameter/progress", 0.0, 0.4)
	$AxeSound.play()
	

func create_apples(num: int = (3 - $Apples.get_children().size())):
	if health > 0:
		var apple_markers = $AppleSpawnPositions.get_children().duplicate(true)
		for i in num:
			var pos_marker = apple_markers.pop_at(randi_range(0, apple_markers.size() - 1))
			var sprite = Sprite2D.new()
			sprite.texture = apple_texture
			$Apples.add_child(sprite)
			for apple in $Apples.get_children():
				if apple.position == pos_marker.position:
					pass
				else:
					sprite.position = pos_marker.position
		
func get_apple():
	if $Apples.get_children():
		$Apples.get_children().pick_random().queue_free()
		Global.change_item(Global.Item.APPLE)
