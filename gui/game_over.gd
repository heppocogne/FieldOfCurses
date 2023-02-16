extends VBoxContainer


func _on_Player_killed():
	visible=true
	var play_time:=int(GlobalScript.world.time_passed)
	$GridContainer/PlayTimeValue.text=str(play_time/60)+":"+str(play_time%60)
	$GridContainer/KillsValue.text=str(GlobalScript.world.kills_count)


func _on_Retry_pressed():
	get_tree().reload_current_scene()


func _on_Quit_pressed():
	get_tree().quit(0)
