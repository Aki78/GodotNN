extends Node

var in_size = 1
var out_size = 1
var n_layers = 3
var n_nodes = 3

var n_population = 10
var population = []
var children = []
var select_deviation = 0.01
var mutation_rate = 0.001

var nn = preload("res://NN.tscn")

func _ready():
	randomize()

func init_ga():
	init_pop(population)
	init_pop(children)

func init_pop(pop):
	for i in n_population:
		var new_nn = nn.instance()
		new_nn.init_weights(in_size, out_size, n_nodes, n_layers)
		new_nn.init_biases(n_nodes, n_layers)
		pop.append(new_nn)

func swap_dna(a,b):
	var new_dna = [] 
	for i in a.size():
		var buf = [a[i].duplicate(true), b[i].duplicate(true)] # need to copy ??
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

func mutate_biases(bs):
	#add a gaussian distributed value to each dna sequence
	var rng = RandomNumberGenerator.new()
	for i in bs.size():
		for j in bs[i].size():
				bs[i][j] += rng.randfn(0,mutation_rate)

func rearrange_population(fitness):
	var arranged_population = []
	for i in fitness.size():
		var max_index = fitness.find(fitness.max())
		arranged_population.append( population[max_index])
		# replace the max value with a very low value so the next max can be found
		fitness[max_index] = -1e16
	return arranged_population

func select_population_index():
	var rng = RandomNumberGenerator.new()
	# for to make sure it doesn't exceede population size
	for i in 100000:
		# get index from gaussian distribution for only the positive side with sigma of the end of pop list
		rng.seed = hash("Godot")
		rng.seed = randi()
		var selected_index =round(abs(rng.randfn(0,select_deviation*population.size())))
		if selected_index < population.size():
			return selected_index

func swap_children_to_population():
	for i in population.size():
		population[i].ws = children[i].ws.duplicate(true)
		population[i].bs = children[i].bs.duplicate(true)

func get_outputs(inp):
	var outputs = []
	for i in population.size():
		outputs.append(population[i].feed_forward(inp))
	return outputs

func mate(fitness):
	population = rearrange_population(fitness)
	for i in population.size():
		var i1 = select_population_index()
		var i2 = select_population_index()
		children[i].ws = swap_dna(population[i1].ws, population[i2].ws)
		children[i].bs = swap_dna(population[i1].bs, population[i2].bs)
		mutate_weights(children[i].ws)
		mutate_biases(children[i].bs)
	swap_children_to_population()
