class_name Machine extends StaticBody2D

var coord: Vector2i

func setup(pos: Vector2, _level: Node2D, parent: Node2D):
	coord = pos / 16
	position = pos
	parent.add_child(self)

func delete(coordinate):
	if coord == coordinate:
		queue_free()
