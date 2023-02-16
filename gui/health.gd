extends HBoxContainer


func _on_Player_hp_changed(diff:int):
	if diff==1:
		add_child(preload("res://gui/life.tscn").instance())
	elif diff==-1:
		remove_child(get_child(get_child_count()-1))
