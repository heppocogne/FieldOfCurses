tool
extends Character

const SQRT_2:=sqrt(2)


func _ready():
	pass


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
			move_vector=Vector2(-SQRT_2,-SQRT_2)/2
			direction=Directions.UL
		elif d:
			move_vector=Vector2(-SQRT_2,SQRT_2)/2
			direction=Directions.DL
		else:
			move_vector=Vector2.LEFT
			direction=Directions.L
	elif r:
		if u:
			move_vector=Vector2(SQRT_2,-SQRT_2)/2
			direction=Directions.UR
		elif d:
			move_vector=Vector2(SQRT_2,SQRT_2)/2
			direction=Directions.DR
		else:
			move_vector=Vector2.RIGHT
			direction=Directions.R
	elif u:
		move_vector=Vector2.UP
		direction=Directions.U
	elif d:
		move_vector=Vector2.DOWN
		direction=Directions.D
	
	position+=speed*move_vector*delta
