extends Node2D

var in_house: bool:
	set(value):
		in_house = value
		$WallsLayer.set_cell(door_cell, 0, Vector2i.ONE if value else Vector2i(0,4))
		var tween = create_tween()
		tween.tween_property($RoofTiles, "modulate:a", 0.0 if in_house else 1.0, 0.5)
var door_cell: Vector2i

func _ready() -> void:
	for cell in $WallsLayer.get_used_cells():
		$FloorTiles.set_cell(cell, 0, Vector2i.ZERO)
		if $WallsLayer.get_cell_atlas_coords(cell) == Vector2i(0,4):
			door_cell = cell
			
func _on_house_area_body_entered(_body: Node2D) -> void:
	in_house = true

func _on_house_area_body_exited(_body: Node2D) -> void:
	in_house = false
