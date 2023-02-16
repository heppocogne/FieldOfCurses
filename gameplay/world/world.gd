extends Node2D

var noise:OpenSimplexNoise
var generated_chunks:Array
var curse_values:Dictionary
var time_passed:float=0
var kills_count:int=0
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
	
	for y in range(-32,32):
		for x in range(-32,32):
			_update_cell(Vector2(x,y))


func _process(delta):
	camera.position=player.position
	time_passed+=delta


func _get_noise(cell_pos:Vector2)->float:
	return range_lerp(noise.get_noise_2dv(cell_pos),-1,1,0,6)


func _update_cell(cell:Vector2):
	var cv:float=_get_curse(cell)
	if cv<1:	# [0,1)
		layer1.set_cellv(cell,0)
	elif cv<2:	# [1,2)
		layer1.set_cellv(cell,1)
	elif cv<3:	# [2,3)
		layer1.set_cellv(cell,2)
	elif cv<4:	# [3,4)
		layer1.set_cellv(cell,3)
	elif cv<5:	# [4,5)
		layer1.set_cellv(cell,4)
	else:	# 5~
		layer1.set_cellv(cell,5)


func add_curses(cells_and_values:Dictionary):
	for cell in cells_and_values:
		if curse_values.has(cell):
			curse_values[cell]+=cells_and_values[cell]
		else:
			curse_values[cell]=_get_noise(cell)+cells_and_values[cell]
		
		_update_cell(cell)


func _get_curse(cell_pos:Vector2)->float:
	if curse_values.has(cell_pos):
		return curse_values[cell_pos]
	else:
		return _get_noise(cell_pos)


func _on_SpawnTimer_timeout():
	if player.dead:
		return
	
	var spawnable_cells:=[]
	var player_cell:=GlobalScript.player.position/16
	for y in range(-32,32):
		for x in range(-32,32):
			if Vector2(x,y).length_squared()<100:
				continue
			if 3<=layer1.get_cellv(Vector2(x,y)):
				spawnable_cells.push_back(Vector2(x,y))
	
	if !spawnable_cells.empty():
		var cell:Vector2=spawnable_cells[randi()%spawnable_cells.size()]
		var pos:=layer1.map_to_world(cell)
#		print_debug(cell)
		var slime:Monster
		if 5<=_get_curse(cell) or (randi()%2==0 and 4<=_get_curse(cell)):
			slime=preload("res://gameplay/characters/red_slime.tscn").instance()
		else:
			slime=preload("res://gameplay/characters/slime.tscn").instance()
		slime.connect("killed",self,"_on_Monster_killed")
		slime.position=layer1.to_global(pos)
		add_child(slime)
		var effect:Effect=preload("res://gameplay/effect/shadow_effect.tscn").instance()
		effect.position=slime.position
		add_child(effect)


func _on_Monster_killed():
	kills_count+=1


func _on_Player_max_point_changed(_max_pt:int):
	$SpawnTimer.wait_time=max($SpawnTimer.wait_time-0.5,1)
