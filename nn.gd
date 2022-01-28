extends Node

var ws = []
var bs = []
var inp = []
var out = []

var in_size = 3
var out_size = 6
var n_layers = 1
var n_nodes = 5

func _ready():
	init_weights(in_size,out_size,n_nodes,n_layers)
	init_biases(n_nodes,n_layers)
	print(ws)
	print(bs)
	inp = zeros_vec(in_size)
	out = feed_forward(inp)
	print(out)

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

func add_biases(vec, biases):
	var b_vec = []
	for i in biases.size():
		b_vec.append(vec[i] + biases[i])
	return b_vec

func init_weights(inSize, outSize, n_node, n_layer):
	ws.append(ones_mat(inSize, n_node))
	if n_layer > 1:
		for i in n_layer - 1:
			ws.append(ones_mat(n_node,n_node))
	ws.append(ones_mat(n_node, outSize))

func init_biases(n_node, n_layer):
	bs.append(ones_vec(n_node))
	if n_layer > 1:
		for i in n_layer - 1:
			bs.append(ones_vec(n_node))

func multiply_vec(vec, mat):
	var new_vec = zeros_vec(mat.size())
	for i in range(new_vec.size()):
		for j in range(mat[0].size()): # !!![0]?
			print(i,j)
			new_vec[i] = new_vec[i] + vec[j] * mat[i][j]
	return new_vec

func act_tanh(vec):
	var act_vec = []
	for i in vec.size():
		act_vec.append(tanh(vec[i]))
	return act_vec

func feed_forward(input):
	print(ws[-1])
	var new_vec = act_tanh(add_biases(multiply_vec(input, ws[0]), bs[0]))
	if ws.size() > 1:
		for i in ws.size()-2:
			print(i)
			new_vec = act_tanh(add_biases(multiply_vec(new_vec, ws[i+1]), bs[i+1]))
	print("out loop")
	print(new_vec)
	new_vec = multiply_vec(new_vec, ws[-1])
	return new_vec



