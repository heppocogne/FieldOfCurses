tool
class_name Monster
extends Character

const SPREAD_THRESHHOLD=0.01

export var curse:float=1

var player_entered:=false
var diag:=1.0

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
	if GlobalScript.player.dead:
		return
	
	var move_vector:=(GlobalScript.player.position-position).normalized()
	
	var dot_max:=-INF
	for dir in DIRECTIONS_MAPPING:
		var dot:float=DIRECTIONS_MAPPING[dir].dot(move_vector)
		if dot_max<dot:
			dot_max=dot
			direction=dir
	
	position+=move_vector*speed*diag*delta


func _physics_process(_delta):
	if Engine.editor_hint:
		return
	
	if player_entered:
		GlobalScript.player.damage(self,attack)
	
	if 32*32<position.distance_to(GlobalScript.player.position):
		queue_free()


func damage(by:Character,amount:int):
	.damage(by,amount)
	var t:Tween=$Tween
	t.interpolate_property(
		self,
		"diag",
		-0.5,
		1.0,
		1.0
	)
	t.start()


func _on_Character_killed():
	var d:=-int(log(SPREAD_THRESHHOLD/curse)/log(2))
	var curse_spread:={}
	var center:Vector2=get_parent().layer1.world_to_map(get_parent().layer1.to_local(position))
	for y in range(-d,d+1):
		for x in range(-d,d+1):
#			print("2^",-Vector2(x,y).length(),"=",pow(2,-Vector2(x,y).length()))
			var curse_value:=curse*pow(2,-Vector2(x,y).length())
			if SPREAD_THRESHHOLD<curse_value:
				curse_spread[center+Vector2(x,y)]=curse_value
#	print_debug(get_parent().layer1.world_to_map(position))
	get_parent().add_curses(curse_spread)
	queue_free()


func _on_Character_area_entered(area:Area2D):
	if area==GlobalScript.player:
		player_entered=true


func _on_Monster_area_exited(area:Area2D):
	if area==GlobalScript.player:
		player_entered=false
