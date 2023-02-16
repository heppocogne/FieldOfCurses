extends Control


func _on_Start_pressed():
	get_tree().change_scene_to(preload("res://gameplay/world/world.tscn"))


func _on_HowToPlay_pressed():
	$CenterContainer/VBoxContainer/HowToPlay/WindowDialog.popup_centered(Vector2(640,480))
