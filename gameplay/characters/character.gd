tool
class_name Character
extends Area2D

signal chunk_changed(new_chunk)

export var speed:float=16
export var animation_fps:float=4
export var max_hp:int=10
export var attack:int=10

onready var sprite:Sprite=$Sprite

enum Directions{
	D,
	DL,
	L,
	DR,
	R,
	UL,
	U,
	UR,
}
var direction:int
var _animation_index:int=1
var _precious_position:Vector2
var _previous_chunk:Vector2=Vector2.INF


func _ready():
	var timer:Timer=$AnimationTimer
	timer.wait_time=1/animation_fps
	timer.start()
	_precious_position=position


func _process(_delta):
	if Engine.editor_hint:
		update()
		sprite=$Sprite
	
	if _animation_index<3:
		sprite.frame=direction*3+_animation_index
	else:
		sprite.frame=direction*3+1


func move(_delta:float):
	pass


func _physics_process(delta):
	if !Engine.editor_hint:
		move(delta)
	
		var chunk:=position/(16*Chunk.CHUNK_SIZE)
		chunk.x=int(chunk.x)
		chunk.y=int(chunk.y)
		if position.x<0:
			chunk.x-=1
		if position.y<0:
			chunk.y-=1
		
		if _previous_chunk!=chunk:
			_previous_chunk=chunk
			emit_signal("chunk_changed",chunk)


func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(-16,-16,32,32),Color.white,false)


func _on_AnimationTimer_timeout():
	_animation_index=(_animation_index+1)%4
