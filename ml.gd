extends Node

var inps = [[-0.1], [0.1]]
var outs = [[-0.1], [0.1]]
var GA = preload("res://GeneticAlgorithm.tscn")
var fitness = []
var preds = []
var ga = GA.instance()
#since fitness has to be integer so it can rearrange in geneticl algorithm
var scale_fitness = 1e10

var max_ittr = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	ga.init_ga()
	var initial_mut_rate = ga.mutation_rate
	for i in max_ittr:
		set_prediction()
		get_fitness()
		ga.mutation_rate = ga.mutation_rate -  initial_mut_rate/max_ittr
		#print(ga.mutation_rate)
		#print(fitness)
		ga.mate(fitness)
   
	#print(preds)
	get_fitness()
	print(fitness)

func get_fitness():
	fitness = []
	for j in preds[0].size():
		var my_sum  = 0
		for i in outs.size():
			for k in outs[0].size():
				my_sum += (preds[i][j][k] - outs[i][k])*(preds[i][j][k] - outs[i][k])
		fitness.append(round(-scale_fitness*my_sum))

func set_prediction():
	preds = []
	for i in inps.size():
		preds.append(ga.get_outputs(inps[i]))
