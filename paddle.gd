extends Node2D

var paddle_speed = 3

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#position.y = get_global_mouse_position().y

func control(press):
	position.y = clamp( position.y, 0 , 600)
	set_position(Vector2(position.x, position.y + paddle_speed*press))


