class_name Weapon
extends Node2D


export var atack_angle_degrees:float=30
export var cool_down:float=1.0
export var damage:=5
export var maximum_targets:=1
export var knockback:float=1.0

onready var cooldown_timer:Timer=$CoolDownTimer

var _atack_angle:=deg2rad(atack_angle_degrees)/2


func attack():
	if cooldown_timer.time_left==0:
		attack_impl()


func attack_impl():
	pass
