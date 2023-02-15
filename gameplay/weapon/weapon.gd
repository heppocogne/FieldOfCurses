class_name Weapon
extends Node2D


export var attack_angle_degrees:float=30
export var cooldown:float=1.0
export var damage:=5
export var maximum_targets:=1
export var knockback:float=1.0

onready var cooldown_timer:Timer=$CoolDownTimer
var _attack_angle:float


func _ready():
	$CoolDownTimer.wait_time=cooldown
	_attack_angle=deg2rad(attack_angle_degrees)/2
	_on_Tween_tween_all_completed()


func attack():
	if cooldown_timer.time_left==0:
		_attack_impl()
		cooldown_timer.start()


func _attack_impl():
	var enemies:Array=$AttackArea.get_overlapping_areas()
	var count:=0
	_attack_effect()
	for enemy in enemies:
		var angle_diff:float=enemy.position.angle_to_point(GlobalScript.player.position)-rotation
		if PI<angle_diff:
			angle_diff-=TAU
		elif angle_diff<-PI:
			angle_diff+=TAU
		if abs(angle_diff)<=_attack_angle:
			enemy.damage(GlobalScript.player,damage)
			var effect:SlashEffect=preload("res://gameplay/effect/slash_effect.tscn").instance()
			effect.rotation=enemy.position.angle_to_point(GlobalScript.player.position)+deg2rad(-135)
			effect.position=enemy.position
			GlobalScript.world.add_child(effect)


func _attack_effect():
	$Tween.interpolate_property(
		$SpritePaqrent,
		"rotation",
		_attack_angle,
		-_attack_angle,
		0.1
	)
	$Tween.start()
	$AudioStreamPlayer.play()


func _on_Tween_tween_all_completed():
	$SpritePaqrent.rotation=_attack_angle
