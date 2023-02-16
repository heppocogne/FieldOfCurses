extends HBoxContainer

const THRESHHOLD:=0.01

const upgrade_scenes:=[
	preload("res://gameplay/gui/enhance_attack_damage.tscn"),
	preload("res://gameplay/gui/enhance_attack_knockback.tscn"),
	preload("res://gameplay/gui/enhance_attack_speed.tscn"),
	preload("res://gameplay/gui/enhance_attack_targets.tscn"),
	preload("res://gameplay/gui/regeneration.tscn"),
	preload("res://gameplay/gui/transient_protection.tscn"),
	preload("res://gameplay/gui/purify.tscn"),
]


func _on_Player_max_point_changed(_max_pt:int):
	var ids:=[]
	while ids.size()<3:
		var id:=randi()%upgrade_scenes.size()
		if !ids.has(id):
			ids.push_back(id)
	
	for i in 3:
		var instance:Upgrade=upgrade_scenes[ids[i]].instance()
		instance.connect("selected",self,"_on_Upgrade_selected")
		add_child(instance)
	
	get_tree().paused=true


func _on_Upgrade_selected(id:String):
	for c in get_children():
		c.queue_free()
	
	get_tree().paused=false
	
	if id=="invincible":
		GlobalScript.player.get_node("InvincibleTimer").wait_time+=0.25
	elif id=="life":
		GlobalScript.player.hp+=1
		GlobalScript.player.emit_signal("hp_changed",1)
	elif id=="attack_damage":
		GlobalScript.player.weapon.damage+=2
	elif id=="attack_speed":
		GlobalScript.player.weapon.get_node("CoolDownTimer").wait_timer*=0.9
	elif id=="attack_targets":
		GlobalScript.player.weapon.maximum_targets+=1
	elif id=="attack_knockback":
		GlobalScript.player.weapon.knockback+=0.15
	elif id=="purify":
		var d:=-int(log(THRESHHOLD/2)/log(2))
		var curse_remove:={}
		var l1=GlobalScript.world.layer1
		var center:Vector2=l1.world_to_map(l1.to_local(GlobalScript.player.position))
		for y in range(-d,d+1):
			for x in range(-d,d+1):
#				print("2^",-Vector2(x,y).length(),"=",pow(2,-Vector2(x,y).length()))
				var curse_value:=2*pow(2,-Vector2(x,y).length())
				if THRESHHOLD<curse_value:
					curse_remove[center+Vector2(x,y)]=-curse_value
		GlobalScript.world.add_curses(curse_remove)
	else:
		push_error("wrong id:"+id)


func _input(event:InputEvent):
	if event is InputEventMouseButton:
		var mb:=event as InputEventMouseButton
		if mb.pressed and get_rect().has_point(mb.position):
			print_debug("mb.pressed")
