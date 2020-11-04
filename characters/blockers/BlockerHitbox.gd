extends Area2D


func damage():
	get_parent().emit_signal("damaged")
