tool
class_name Monster
extends Character

const SPREAD_THRESHHOLD=0.01

export var mass:float=1
export var curse:float=1

var player_entered:=false

func _ready():
	pass


func _process(_delta):
	if Engine.editor_hint:
		update()
		sprite=$Sprite
	
	if _animation_index<3:
		sprite.frame=direction*3+_animation_index
	else:
		sprite.frame=direction*3+1


func move(delta:float):
	var move_vector:=(GlobalScript.player.position-position).normalized()
	
	var dot_max:=-INF
	for dir in DIRECTIONS_MAPPING:
		var dot:float=DIRECTIONS_MAPPING[dir].dot(move_vector)
		if dot_max<dot:
			dot_max=dot
			direction=dir
	
	position+=move_vector*speed*delta


func _physics_process(_delta):
	if Engine.editor_hint:
		return
	
	if player_entered:
		GlobalScript.player.damage(self,attack)
	
		queue_free()


func damage(by:Character,amount:int):
	.damage(by,amount)


func _on_Character_killed():
	queue_free()


func _on_Character_area_entered(area:Area2D):
	if area==GlobalScript.player:
		player_entered=true


func _on_Monster_area_exited(area:Area2D):
	if area==GlobalScript.player:
		player_entered=false
