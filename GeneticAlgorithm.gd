extends Node

var in_size = 3
var out_size = 6
var n_layers = 8
var n_nodes = 5

var n_population = 10
var population = []
var children = []

var inp = [1,2,3,4]
var nn = preload("res://NN.tscn")

func _ready():
	var a = [1,2,3]
	var b = a.duplicate()
	b[1] = 100
	print(a, b)
	populate()

func populate():
	init_population(population)
	init_population(children)

func init_population(pop):
	for i in n_population:
		var new_nn = nn.instance()
		new_nn.init_weights(in_size, out_size, n_nodes, n_layers)
		new_nn.init_biases(n_nodes, n_layers)
		pop.append(new_nn)

func swap_dna(a,b):
	var new_dna = [] 
	for i in a.size():
		var buf = [a[i], b[i]] # need to copy ??
		var rand_index = randi() % 2
		new_dna.append(buf[rand_index])
	return new_dna

func mutate_dna(c,mut_rate):
	#add a gaussian distributed value to each dna sequence
	var new_dna = []
	var rng = RandomNumberGenerator.new()
	for i in c.size():
		new_dna.append(c[i] + rng.randfn(0,mut_rate))
	return new_dna

func rearrange_population(fitness):
	var arranged_population = []
	for i in fitness.size():
		var max_index = fitness.find(fitness.max())
		arranged_population[i] = population[max_index]
		# replace the max value with a very low value so the next max can be found
		fitness[max_index] = 1e-16
	return arranged_population

func select_population_index(sigma):
	var rng = RandomNumberGenerator.new()
	# for to make sure it doesn't exceede population size
	for i in 100000:
		# get index from gaussian distribution for only the positive side with sigma of the end of pop list
		var selected_index = floor(abs(rng.randfn(0,sigma*population.size())))
		if selected_index < population.size():
			return selected_index

func swap_children_to_population():
	for i in population.size():
		population[i].ws = children[i].ws.duplicate()

func mate(fitness):
	population = rearrange_population(fitness)
	for i in population.size():
		var i1 = select_population_index(0.5)
		var i2 = select_population_index(0.5)
		children[i].ws = swap_dna(population[i1].ws, population[i2].ws)
		children[i].bs = swap_dna(population[i1].bs, population[i2].bs)
		children[i].ws = mutate_dna(children[i].ws, 0.1)
		children[i].bs = mutate_dna(children[i].bs, 0.1)

	swap_children_to_population()
