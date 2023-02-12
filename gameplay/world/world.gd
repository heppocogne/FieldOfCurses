extends Node2D

var noise:OpenSimplexNoise
var generated_chunks:Array
var loaded_chunks:Dictionary
onready var camera:Camera2D=$Camera2D
onready var player:Character=$Player


func _ready():
	GlobalScript.world=self
	
	randomize()
	noise=OpenSimplexNoise.new()
	noise.period=16
	noise.lacunarity=0.3
	noise.seed=randi()
	generated_chunks=[]
	loaded_chunks={}
	
	var dir:=Directory.new()
	if !dir.dir_exists("user://world"):
		dir.make_dir("user://world")


func _process(_delta):
	camera.position=player.position


func _on_Player_chunk_changed(new_chunk:Vector2):
	for y in range(-1,2):
		for x in range(-1,2):
			var chunk_position:=new_chunk+Vector2(x,y)
			if loaded_chunks.has(chunk_position):
				continue
			elif !generated_chunks.has(chunk_position):
				# generate
				print_debug("generate",chunk_position)
				var chunk:=Chunk.new()
				chunk.topleft_position=Chunk.CHUNK_SIZE*chunk_position
				for chy in Chunk.CHUNK_SIZE:
					for chx in Chunk.CHUNK_SIZE:
						var n:=noise.get_noise_2dv(chunk.topleft_position+Vector2(chx,chy))
						chunk.curse_levels[chunk.topleft_position+Vector2(chx,chy)]=range_lerp(n,-1,1,0,7)
				chunk.update_cells($Layer1)
				generated_chunks.push_back(chunk_position)
				loaded_chunks[chunk_position]=chunk
			else:
				# load
				print_debug("load",chunk_position)
				var f:=File.new()
				if f.open_compressed("user://world"+str(chunk_position)+".var.zstd",File.READ,File.COMPRESSION_ZSTD)==OK:
					var data:Dictionary=f.get_var()
					var chunk:Chunk=Chunk.deserialize(data)
#					add_child(chunk)
					loaded_chunks[chunk_position]=chunk
#					var data:Chunk=f.get_var(true)
#					add_child(data)
	
	for c in loaded_chunks.keys():
		var diff:Vector2=c-new_chunk
		if 2<=abs(diff.x) or 2<=abs(diff.y):
			# unload
			print_debug("unload",c)
			var f:=File.new()
			if f.open_compressed("user://world"+str(c)+".var.zstd",File.WRITE,File.COMPRESSION_ZSTD)==OK:
				f.store_var(loaded_chunks[c].serialize())
				loaded_chunks[c].free()
				loaded_chunks.erase(c)
#				f.store_var(loaded_chunks[c],true)
	print_debug(loaded_chunks.keys())
