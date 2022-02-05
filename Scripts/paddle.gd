extends Node2D

var paddle_speed = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func control(press):
	position.y = clamp(position.y, 0, 600)
	set_position(Vector2(position.x, position.y + paddle_speed*press))



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
