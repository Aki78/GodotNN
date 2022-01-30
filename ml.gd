extends Node

var inps = [[0.1], [0.2], [0.3]]
var outs = [[0.1], [0.2], [0.3]]
var GA = preload("res://GeneticAlgorithm.tscn")
var fitness = []
var preds = []
var ga = GA.instance()
#since fitness has to be integer so it can rearrange in geneticl algorithm
var scale_fitness = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	ga.init_ga()
	for i in 1000:
		set_prediction()
		get_fitness()
		ga.mate(fitness)
   
	print(preds)

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
