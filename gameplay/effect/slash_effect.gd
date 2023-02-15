class_name SlashEffect
extends Sprite


func _on_Timer_timeout():
	if frame==4:
		queue_free()
	else:
		frame+=1
