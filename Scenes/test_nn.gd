extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var in_size = 3
var out_size = 2
var n_nodes = 2
var n_layers = 2

var input = [1,1,1]

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().init_weights_ones(in_size, out_size, n_nodes, n_layers)
	get_parent().init_biases_ones( n_nodes, n_layers)
	print(get_parent().feed_forward(input)) # prints [1.9901, 1.9901] around
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
