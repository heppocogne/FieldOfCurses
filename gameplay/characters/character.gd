tool
class_name Character
extends Area2D

const SQRT_2:=sqrt(2)

signal killed()

export var speed:float=64
export var animation_fps:float=4
export var max_hp:int=10
export var attack:int=10

onready var sprite:Sprite=$Sprite
var hp:int

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
var direction:int=Directions.D
var _animation_index:int=1

const DIRECTIONS_MAPPING:={
	Directions.D:Vector2.DOWN,
	Directions.DL:Vector2(-SQRT_2,SQRT_2)/2,
	Directions.L:Vector2.LEFT,
	Directions.DR:Vector2(SQRT_2,SQRT_2)/2,
	Directions.R:Vector2.RIGHT,
	Directions.UL:Vector2(-SQRT_2,-SQRT_2)/2,
	Directions.U:Vector2.UP,
	Directions.UR:Vector2(SQRT_2,-SQRT_2)/2,
}


func _ready():
	hp=max_hp
	var timer:Timer=$AnimationTimer
	timer.wait_time=1/animation_fps
	timer.start()


func move(_delta:float):
	pass


func _physics_process(delta):
	if !Engine.editor_hint:
		move(delta)


func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(-16,-16,32,32),Color.white,false)


func _on_AnimationTimer_timeout():
	_animation_index=(_animation_index+1)%4


func damage(_by:Character,amount:int):
	hp-=amount
	if hp<=0:
		emit_signal("killed")


func _on_Character_killed():
	pass


func _on_Character_area_entered(_area:Area2D):
	pass
