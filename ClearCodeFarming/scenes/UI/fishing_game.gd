extends Node2D

@onready var y_range = $Control/NinePatchRect.custom_minimum_size.y - 10
var bar_velocity: float
var fish_velocity: float
var progress := 30.0
var sprite_size: Vector2

func _ready():
	hide()
	sprite_size = $FishingBar.get_rect().size
	
func _process(delta: float) -> void:
	if visible:
		$Fish.position.y += fish_velocity * delta
		$Fish.position.y = clamp($Fish.position.y, -y_range/2.0, y_range/2.0)
		var half_bar_height = sprite_size.y / 2 - 2
		bar_velocity += 20 * delta
		$FishingBar.position.y += bar_velocity * delta
		$FishingBar.position.y = clamp($FishingBar.position.y, -y_range/2.0 + half_bar_height, y_range/2.0 - half_bar_height)
		var top_point = $FishingBar.position.y - sprite_size.y/2
		var bottom_point = $FishingBar.position.y + sprite_size.y/2
		if top_point <= $Fish.position.y and $Fish.position.y <= bottom_point:
			progress += 10 * delta
		else:
			progress -= 10 * delta
		$Control/TextureProgressBar.value = progress
		
func reveal():
	show()
	$Fish.position.y = randf_range(-y_range/2.0, y_range/2.0)
	fish_velocity = randf_range(-20, 20)

func _on_fish_update_timer_timeout() -> void:
	fish_velocity = randf_range(-20, 20)
	$FishUpdateTimer.wait_time = randf_range(1, 3)

func action():
	bar_velocity = -25


func _on_texture_progress_bar_value_changed(value: float) -> void:
	if value <= 0 or value >= 100:
		hide()
		Global.change_item(Global.Item.FISH, 1 if value >= 100 else 0)
		get_parent().stop_fishing()
