class_name Upgrade
extends PanelContainer

signal selected(id)

export var upgrade_id:String

func _input(event:InputEvent):
	if event is InputEventMouseButton:
		var mb:=event as InputEventMouseButton
		if mb.pressed and get_global_rect().has_point(mb.position):
			print_debug("selected")
			emit_signal("selected",upgrade_id)
