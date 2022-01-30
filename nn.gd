extends Node

var ws = []
var bs = []

func _ready():
	randomize()

func zeros_mat(nX, nY):
	var mat = []
	for x in range(nX):
		mat.append([])
		for _y in range(nY):
			mat[x].append(0)
	return mat

func ones_mat(nY, nX):
	var mat = []
	for x in range(nX):
		mat.append([])
		for _y in range(nY):
			mat[x].append(1)
	return mat


func rand_mat(nY, nX):
	var mat = []
	for x in range(nX):
		mat.append([])
		for _y in range(nY):
			mat[x].append(rand_range(-1,1))
	return mat

func zeros_vec(nX):
	var vec = []
	for _x in range(nX):
		vec.append(0)
	return vec

func ones_vec(nX):
	var vec = []
	for _x in range(nX):
		vec.append(1)
	return vec

func rand_vec(nX):
	var vec = []
	for _x in range(nX):
		vec.append(rand_range(-1,1))
	return vec

func add_biases(vec, biases):
	var b_vec = []
	for i in biases.size():
		b_vec.append(vec[i] + biases[i])
	return b_vec

func init_weights(in_size, out_size, n_node, n_layer):
	ws.append(rand_mat(in_size, n_node))
	if n_layer > 1:
		for i in n_layer - 1:
			ws.append(rand_mat(n_node,n_node))
	ws.append(rand_mat(n_node, out_size))

func init_biases(n_node, n_layer):
	bs.append(rand_vec(n_node))
	if n_layer > 1:
		for i in n_layer - 1:
			bs.append(rand_vec(n_node))

func multiply_vec(vec, mat):
	var new_vec = zeros_vec(mat.size())
	for i in range(new_vec.size()):
		for j in range(mat[0].size()): # !!![0]?
			new_vec[i] = new_vec[i] + vec[j] * mat[i][j]
	return new_vec

func act_tanh(vec):
	var act_vec = []
	for i in vec.size():
		act_vec.append(tanh(vec[i]))
	return act_vec

func feed_forward(input):
	var new_vec = act_tanh(add_biases(multiply_vec(input, ws[0]), bs[0]))
	if ws.size() > 1:
		for i in ws.size()-2:
			new_vec = act_tanh(add_biases(multiply_vec(new_vec, ws[i+1]), bs[i+1]))
	# output layer linear		
	new_vec = multiply_vec(new_vec, ws[-1])
	print("ws-1: ", ws[-1])
	return new_vec
