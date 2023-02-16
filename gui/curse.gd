extends Label


func _on_Player_player_cell(id:int):
	if id==3:
		text="Curse 1: Speed -10%"
	elif id==4:
		text="Curse 2: Speed -20%"
	elif id==5:
		text="Curse 3: Speed -25%, Take damage"
	else:
		text="Curse 0: No effect"
	
	if 3<=id:
		add_color_override("font_color",Color.red)
	else:
		add_color_override("font_color",Color.blue)
