extends KinematicBody2D


var speed = 50
var gravity =  100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#move_and_slide(Vector2(1,1+gravity))
	move_and_slide(Vector2(0, gravity))



	if Input.is_action_pressed("ui_right"):
		move_and_slide(Vector2(speed,0))
	if Input.is_action_pressed("ui_left"):
		move_and_slide(Vector2(-speed,0))
