extends Node2D

var noise:OpenSimplexNoise


func _ready():
	randomize()
	noise=OpenSimplexNoise.new()
	noise.seed=randi()
