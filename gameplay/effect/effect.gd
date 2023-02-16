class_name Effect
extends Sprite

export var max_frame:=1


func _process(_delta):
	if frame==max_frame:
		queue_free()
	else:
		frame+=1
