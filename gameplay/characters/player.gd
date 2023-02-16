tool
class_name Player
extends Character

var invincible:=false
var dead:=false
onready var weapon:Weapon=$LongSword
onready var points:int=0
onready var audio:AudioStreamPlayer=$AudioStreamPlayer
onready var audio2:AudioStreamPlayer=$AudioStreamPlayer2

var next_upgrade:=10


func _ready():
	if Engine.editor_hint:
		return
	
	GlobalScript.player=self
	$Tween.interpolate_property(
		$Sprite,
		"self_modulate:a",
		1.0,
		0.5,
		0.2
	)


func _process(_delta):
	if Engine.editor_hint:
		update()
		sprite=$Sprite
	else:
		var dir_vector:=get_local_mouse_position().normalized()
		var dot_max:=-INF
		for dir in DIRECTIONS_MAPPING:
			var dot:float=DIRECTIONS_MAPPING[dir].dot(dir_vector)
			if dot_max<dot:
				dot_max=dot
				direction=dir
	
	if _animation_index<3:
		sprite.frame=direction*3+_animation_index
	else:
		sprite.frame=direction*3+1


func _input(event:InputEvent):
	if dead:
		return
	
	if event is InputEventMouseButton:
		var mb:=event as InputEventMouseButton
		if mb.button_index==BUTTON_LEFT and mb.pressed:
			if weapon:
				weapon.attack()
	if event is InputEventMouseMotion:
		if weapon:
			weapon.rotation=get_local_mouse_position().angle()


func move(delta:float):
	if dead:
		return
	
	var l:=Input.is_action_pressed("game_left")
	var r:=Input.is_action_pressed("game_right")
	var u:=Input.is_action_pressed("game_up")
	var d:=Input.is_action_pressed("game_down")
	
	if l&&r:
		l=false
		r=false
	
	if u&&d:
		u=false
		d=false
	
	var move_vector:=Vector2.ZERO
	if l:
		if u:
			direction=Directions.UL
		elif d:
			direction=Directions.DL
		else:
			direction=Directions.L
	elif r:
		if u:
			direction=Directions.UR
		elif d:
			direction=Directions.DR
		else:
			direction=Directions.R
	elif u:
		direction=Directions.U
	elif d:
		direction=Directions.D
	else:
		return
	
	move_vector=DIRECTIONS_MAPPING[direction]
	var l1:TileMap=get_parent().layer1
	var cell:int=l1.get_cellv(l1.world_to_map(l1.to_local(position)))
	if cell==3:
		move_vector*=0.9
	elif cell==4:
		move_vector*=0.8
	elif cell==5:
		move_vector*=0.75
		damage(null,1)
	position+=speed*move_vector*delta
	position.x=clamp(position.x,-32*32,32*32)
	position.y=clamp(position.y,-32*32,32*32)


func _on_Character_killed():
	visible=false
	dead=true


func _on_InvincibleTimer_timeout():
	invincible=false
	$Tween.stop(sprite)
	sprite.self_modulate.a=1


func damage(by:Character,amount:int):
	if !invincible and !dead:
		.damage(by,amount)
		invincible=true
		$Tween.start()
		$InvincibleTimer.start()
		audio2.play()
		print_debug("hp:",hp)


func _on_Character_area_entered(area:Area2D):
	if area is Item:
		points+=area.point
		area.queue_free()
		audio.play()
		print_debug("points=",points)
