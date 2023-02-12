extends Node2D

var noise:OpenSimplexNoise
var generated_chunks:Array
var curse_values:Dictionary
onready var layer1:TileMap=$Layer1
onready var camera:Camera2D=$Camera2D
onready var player:Character=$Player


func _ready():
	GlobalScript.world=self
	
	randomize()
	noise=OpenSimplexNoise.new()
	noise.period=16
	noise.lacunarity=0.3
	noise.seed=randi()
	print_debug("set seed")
	generated_chunks=[]
	curse_values={}
	
	var dir:=Directory.new()
	if !dir.dir_exists("user://world"):
		dir.make_dir("user://world")


func _process(_delta):
	camera.position=player.position


func _get_noise(cell_pos:Vector2)->float:
	return range_lerp(noise.get_noise_2dv(cell_pos),-1,1,0,6)


func _get_curse(cell_pos:Vector2)->float:
	if curse_values.has(cell_pos):
		return curse_values[cell_pos]
	else:
		return _get_noise(cell_pos)


func _on_Player_chunk_changed(new_chunk:Vector2):
	for y in range(-1,2):
		for x in range(-1,2):
			var chunk_position:=new_chunk+Vector2(x,y)
			if !generated_chunks.has(chunk_position):
				# generate
				print_debug("generate",chunk_position)
				var topleft_position=32*chunk_position
				for chy in 32:
					for chx in 32:
						var cell_pos:Vector2=topleft_position+Vector2(chx,chy)
						var n:=_get_noise(cell_pos)
						if n<1:	# [0,1)
							layer1.set_cellv(cell_pos,0)
						elif n<2:	# [1,2)
							layer1.set_cellv(cell_pos,1)
						elif n<3:	# [2,3)
							layer1.set_cellv(cell_pos,2)
						elif n<4:	# [3,4)
							layer1.set_cellv(cell_pos,3)
						elif n<5:	# [4,5)
							layer1.set_cellv(cell_pos,4)
						else:	# 5~
							layer1.set_cellv(cell_pos,5)
				generated_chunks.push_back(chunk_position)


func _on_SpawnTimer_timeout():
	var spawnable_cells:=[]
	var player_cell:=GlobalScript.player.position/16
	for y in range(-30,30):
		for x in range(-30,30):
			if Vector2(x,y).length_squared()<100:
				continue
			if 3<=layer1.get_cellv(player_cell+Vector2(x,y)):
				spawnable_cells.push_back(player_cell+Vector2(x,y))
	
	if !spawnable_cells.empty():
		var cell:Vector2=spawnable_cells[randi()%spawnable_cells.size()]
		var pos:=layer1.map_to_world(cell)
		print_debug(cell)
		var slime:Monster=preload("res://gameplay/characters/slime.tscn").instance()
		slime.position=layer1.to_global(pos)
		add_child(slime)
