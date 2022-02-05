extends RigidBody2D

var score = [0, 0]
var started = false
var direction = 0
var frames = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(Vector2(0,0),Vector2(500,0))
	friction = -1
	get_node("start").start()

	
func set_direction():
	if linear_velocity.x > 0:
		direction = 1
	else:
		direction = -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	frames += 1
	#print(frames)

	if abs(linear_velocity.x) < 100 &&  started:
		print("bang")
		set_direction()
		apply_impulse(Vector2(0,0),Vector2(100*direction,0))

func _process(delta):
	pass

	
func _on_net_body_entered(body):
	score[1] += 1 



func _on_net2_body_entered(body):
	score[0] += 1 


func _on_start_timeout():
	print("started")
	started = true
