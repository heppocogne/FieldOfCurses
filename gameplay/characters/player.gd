tool
extends Character

var invincible:=false
var weapon:Weapon


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
	if event is InputEventMouseButton:
		var mb:=event as InputEventMouseButton
		if mb.button_index==BUTTON_LEFT and mb.pressed:
			if weapon:
				weapon.attack()


func move(delta:float):
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
	position+=speed*move_vector*delta


func _on_Character_killed():
	visible=false


func _on_InvincibleTimer_timeout():
	invincible=false
	$Tween.stop(sprite)
	sprite.self_modulate.a=1


func damage(by:Character,amount:int):
	if !invincible:
		.damage(by,amount)
		invincible=true
		$Tween.start()
		$InvincibleTimer.start()
