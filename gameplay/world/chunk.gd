class_name Chunk
extends Object

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


func update_cells(l1:TileMap):
	for y in CHUNK_SIZE:
		for x in CHUNK_SIZE:
			var cell_pos:=topleft_position+Vector2(x,y)
			var level:float=curse_levels[cell_pos]
			if level<=1:
				l1.set_cellv(cell_pos,0)
			elif level<=2:
				l1.set_cellv(cell_pos,1)
			elif level<=3:
				l1.set_cellv(cell_pos,2)
			elif level<=4:
				l1.set_cellv(cell_pos,3)
			elif level<=5:
				l1.set_cellv(cell_pos,4)
			elif level<=6:
				l1.set_cellv(cell_pos,5)
			else:
				l1.set_cellv(cell_pos,6)


static func deserialize(data:Dictionary)->Chunk:
	var chunk:Chunk=load("res://gameplay/world/chunk.gd").new()
	chunk.topleft_position=data["topleft_position"]
	chunk.curse_levels=data["curse_levels"]
	return chunk
