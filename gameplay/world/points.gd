extends HBoxContainer

onready var progress_bar:ProgressBar=$ProgressBar
onready var values:Label=$Values


func _on_Player_point_changed(pt:int):
	progress_bar.value=pt
	values.text=str(pt)+"/"+str(progress_bar.max_value)


func _on_Player_max_point_changed(max_pt:int):
	progress_bar.max_value=max_pt
	values.text=str(progress_bar.value)+"/"+str(max_pt)
