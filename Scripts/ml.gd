extends Node
var inps = []
var outs = []
var GA = preload("res://Scenes/GeneticAlgorithm.tscn")
var fitness = []
var preds = []
var ga = GA.instance()
#since fitness has to be integer so it can rearrange in geneticl algorithm
var scale_fitness = 1e10

var max_ittr = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	#inps = [[-1], [1]]
	#outs = [[-10], [10]]
	var x = 0
	for i in 10:
		inps.append([x])
		outs.append([10*sin(x)])
		x += 0.1

	randomize()
	ga.init_ga()
	var initial_mut_rate = ga.mutation_rate
	for i in max_ittr:
		#print("itter: ", i)
		set_prediction()
		get_fitness()
		ga.mutation_rate = ga.mutation_rate -  initial_mut_rate/max_ittr
		#print(ga.mutation_rate)
		#print(fitness)
		ga.mate(inps,fitness)
   
	get_fitness()
	print(outs)
	print(ga.best_pred)
	print(fitness)
	save_level()

func save_level():
	var save_file = File.new()
	save_file.open("res://savefile_compiled.save", File.WRITE)
	save_file.store_line(str(outs))
	save_file.store_line(str(ga.best_pred))
	save_file.store_line(str(fitness))
	save_file.store_line(str(ga.best_nn.ws))
	save_file.store_line(str(ga.best_nn.bs))
	save_file.close()

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
