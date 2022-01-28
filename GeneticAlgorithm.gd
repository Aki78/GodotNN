extends Node

var in_size = 3
var out_size = 6
var n_layers = 8
var n_nodes = 5

var n_population = 10
var population = []

var inp = [1,2,3,4]
var nn = preload("res://NN.tscn")

func _ready():
	#var nn = get_node("NN")
	populate()

func populate():
	for i in n_population:
		var new_nn = nn.instance()
		new_nn.init_weights(in_size, out_size, n_nodes, n_layers)
		new_nn.init_biases(n_nodes, n_layers)
		print(new_nn)
		#population.append(new_nn)
		#inp = new_nn.zeros_vec(in_size)
		#print(new_nn.feed_forward(inp))

func get_fitness():
	pass

func mate():
	pass;

func get_distribution():
	pass;

