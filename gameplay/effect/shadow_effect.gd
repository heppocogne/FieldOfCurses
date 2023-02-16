class_name ShadowEffect
extends Sprite


func _process(_delta):
	if frame==30:
		queue_free()
	else:
		frame+=1
