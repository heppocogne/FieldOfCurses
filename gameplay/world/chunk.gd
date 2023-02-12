class_name Chunk
extends Node2D

const CHUNK_SIZE:=32
var topleft_position:Vector2
var curse_levels:Dictionary


func _ready():
	pass


func serialize()->Dictionary:
	return {
		"topleft_position":topleft_position,
		"curse_levels":curse_levels,
	}


func _update_cells():
	var l1:TileMap=$Layer1
	for y in CHUNK_SIZE:
		for x in CHUNK_SIZE:
			var level:float=curse_levels[topleft_position+Vector2(x,y)]
			if level<=1:
				l1.set_cell(x,y,0)
			elif level<=2:
				l1.set_cell(x,y,1)
			elif level<=3:
				l1.set_cell(x,y,2)
			elif level<=4:
				l1.set_cell(x,y,3)
			elif level<=5:
				l1.set_cell(x,y,4)
			elif level<=6:
				l1.set_cell(x,y,5)
			else:
				l1.set_cell(x,y,6)


static func deserialize(data:Dictionary)->Chunk:
	var chunk:Chunk=load("res://gameplay/world/chunk.tscn").instance()
	chunk.topleft_position=data["topleft_position"]
	chunk.curse_levels=data["curse_levels"]
	return chunk
