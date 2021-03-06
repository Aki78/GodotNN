extends Node

var in_size = 6
var out_size = 2
var n_layers = 5
var n_nodes = 5

var n_population = 100
var population = []
var children = []
var select_deviation = 1.0
var mutation_rate = 0.0001
var best_pred = []
var total_nodes
var clamp_val = 3
var mutation_size = 1.0
var mutation_freq 

var best_nn

var nn = preload("res://Scenes/NN.tscn")

func _ready():
	randomize()
	total_nodes = get_param_numb()
	print("total nodes: ", total_nodes)
	mutation_freq = total_nodes
	print(total_nodes)

func get_param_numb():
	return in_size*n_nodes + n_layers*n_nodes*n_nodes + n_nodes*out_size

func init_ga():
	init_pop(population)
	init_pop(children)

func init_pop(pop):
	for i in n_population:
		var new_nn = nn.instance()
		new_nn.init_weights(in_size, out_size, n_nodes, n_layers)
		new_nn.init_biases(out_size, n_nodes, n_layers)
		pop.append(new_nn)

func swap_dna(a,b):
	var new_dna = [] 
	for i in a.size():
		var buf = [a[i].duplicate(true), b[i].duplicate(true)] # need to copy ?? yes
		var rand_index = randi() % 2
		new_dna.append(buf[rand_index])
	return new_dna

func mutate_weights(ws):
	#add a gaussian distributed value to each dna sequence
	var rng = RandomNumberGenerator.new()
	for i in ws.size():
		for j in ws[i].size():
			for k in ws[i][j].size():
				ws[i][j][k] += rng.randfn(0,mutation_rate)
				if randi() % mutation_freq == 0:
					ws[i][j][k] += rng.randfn(0,mutation_size)
				if ws[i][j][k] > clamp_val:
					ws[i][j][k] = clamp_val
				elif ws[i][j][k] < -clamp_val:
					ws[i][j][k] = -clamp_val
func set_weights_and_biases(weights, biases):
	#add a gaussian distributed value to each dna sequence
	for p in population.size():
		for i in weights.size():
			for j in weights[i].size():
				for k in weights[i][j].size():
					population[p].ws[i][j][k] = weights[i][j][k]
		for i in biases.size():
			for j in biases[i].size():
				population[p].bs[i][j] = biases[i][j] 

func mutate_biases(bs):
	#add a gaussian distributed value to each dna sequence
	var rng = RandomNumberGenerator.new()
	for i in bs.size():
		for j in bs[i].size():
			bs[i][j] += rng.randfn(0,mutation_rate)
			if randi() % mutation_freq == 0:
				bs[i][j] += rng.randfn(0,mutation_size)
			if bs[i][j] > clamp_val:
				bs[i][j] = clamp_val
			elif bs[i][j] < -clamp_val:
				bs[i][j] = -clamp_val

func rearrange_population(fitness):
	var arranged_population = []
	var fitness_buff = fitness.duplicate(true)
	for i in fitness.size():
		var max_index = fitness_buff.find(fitness_buff.max())
		arranged_population.append( population[max_index])
		# replace the max value with a very low value so the next max can be found
		fitness_buff[max_index] = -1e16
	return arranged_population

func select_population_index():
	var rng = RandomNumberGenerator.new()
	# for to make sure it doesn't exceede population size
	for i in 100000:
		# get index from gaussian distribution for only the positive side with sigma of the end of pop list
		rng.seed = hash("Godot")
		rng.seed = randi()
		var gauss_val = rng.randfn(0, select_deviation*population.size())
		var selected_index =round(abs(gauss_val))
		if selected_index < population.size():
			return selected_index

func swap_children_to_population():
	for i in population.size():
		population[i].ws = children[i].ws.duplicate(true)
		population[i].bs = children[i].bs.duplicate(true)
		#if i == population.size() - 1:
			#get_tree().paused = false

func get_outputs(inp):
	var outputs = []
	for i in population.size():
		outputs.append(population[i].feed_forward(inp))
	return outputs

func get_best(fitness):
	var max_index = fitness.find(fitness.max())
	return population[max_index]


func mate(fitness):
	get_tree().paused = true
	
	population = rearrange_population(fitness)
	for i in population.size():
		var i1 = select_population_index()
		var i2 = select_population_index()
		children[i].ws = swap_dna(population[i1].ws, population[i2].ws)
		children[i].bs = swap_dna(population[i1].bs, population[i2].bs)
		mutate_weights(children[i].ws)
		mutate_biases(children[i].bs)
		print(i)
	swap_children_to_population()
	get_tree().paused = false
	#get_tree().paused = false
