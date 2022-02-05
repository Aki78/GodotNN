extends Node2D

var GA = preload("res://Scenes/GeneticAlgorithm.tscn")
var ga1 = GA.instance()
var ga2 = GA.instance()

var current_nn1 
var current_nn2 

var fitness1 = []
var fitness2 = []
var gen_ittr = 1
var physics_ittr = 5000
var popI = 0
var phiI = 0
var ball
var taggle_training = 0
var is_training1 = false
var is_training2 = false
var best_weights1 = []
var best_weights2 = []
var best_biases1 = []
var best_biases2 = []

var save_path =  "res://savefile_bests.save"

var ittr = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	load_json()
	print(best_weights1) 
	ga1.init_ga()
	ga2.init_ga()
	ga1.set_weights_and_biases(best_weights1, best_biases1)
	ga2.set_weights_and_biases(best_weights2, best_biases2)
	add_child(ga1)
	add_child(ga2)
	ball = get_node("ball")
	init_fitness()
	current_nn1 = ga1.population[0]
	current_nn2 = ga2.population[0]

func init_fitness():
	for i in ga1.n_population:
		fitness1.append(0)
		fitness2.append(0)

func game(): 
	if taggle_training == 0:
		one_against_two()
	elif taggle_training == 1:
		two_against_one()

	if is_training1 == true:
		ga1.mate(fitness1)
		is_training1=false

	if is_training2 == true:
		ga2.mate(fitness2)
		is_training2=false
	#two_against_one()

func one_against_two():
	current_nn2 = ga2.get_best(fitness2)
	#After one game
	if phiI == physics_ittr:
		current_nn1 = ga1.population[popI]
		fitness1[popI] = ball.score[0] - ball.score[1]
		popI += 1
		phiI = 0
		print(ball.score)
		print(ball.position)
		ball.score = [0,0]
	# After every population
	if popI == ga1.n_population:
		taggle_training = 1
		popI = 0
		is_training1 = true

func two_against_one():
	current_nn1 = ga1.get_best(fitness1)
	#After one game
	if phiI == physics_ittr:
		current_nn2 = ga2.population[popI]
		fitness2[popI] =ball.score[1] - ball.score[0]
		popI += 1
		phiI = 0
		print(ball.score)
		ball.score = [0,0]
	# After every population
	if popI == ga2.n_population:
		taggle_training = 0
		popI = 0
		is_training2 = true
		save_json()


func save_json():
	var save_file = File.new()
	save_file.open(save_path, File.WRITE)
	var dict = {"best1w" : ga1.get_best(fitness1).ws,"best1b" : ga1.get_best(fitness1).bs, "best2w" : ga2.get_best(fitness2).ws,"best2b" : ga2.get_best(fitness2).bs}

	save_file.store_line(to_json(dict))
	save_file.close()

func load_json():
	var file = File.new()
	if file.file_exists(save_path):
			file.open(save_path,file.READ)
			var tmp_data = file.get_as_text()
			file.close()

			var dict = {}
			dict = parse_json(tmp_data)

			best_weights1 = dict["best1w"]
			best_weights2 = dict["best2w"]
			best_biases1 = dict["best1b"]
			best_biases2 = dict["best2b"]

func _physics_process(delta):
	game()
	#ittr += 1
	#print(ittr)
	var paddle1 = get_node("paddle")
	var paddle2 = get_node("paddle2")
	var ball_pos = ball.position
	var press_direction1 = current_nn1.feed_forward([0.01*ball_pos.x, 0.01*ball_pos.y, 0.01*paddle1.position.y, 0.01*paddle2.position.y])
	var press_direction2 = current_nn2.feed_forward([0.01*ball_pos.x, 0.01*ball_pos.y, 0.01*paddle1.position.y, 0.01*paddle2.position.y])
	press_direction1 = press_direction1[0]
	press_direction2 = press_direction2[0]
	if press_direction1 > 0:
		paddle1.control(+1)
	else:
		paddle1.control(-1)

	if press_direction2 > 0:
		paddle2.control(+1)
	else:
		paddle2.control(-1)

	phiI += 1

