extends Node2D

onready var pause_menu: = $UI/PauseMenu
onready var debug_menu: = $UI/DebugMenu

const CURSOR: = preload("res://ui/hud/crosshair02.png")


func _ready():
	SignalBus.emit_signal("stage_start")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		pause_menu.popup_centered()
	if event.is_action_pressed("ui_end"):
		print_debug("debug")
		get_tree().set_input_as_handled()
		debug_menu.popup_centered()


func _enter_tree():
	Input.set_custom_mouse_cursor(CURSOR)


func _exit_tree():
	Input.set_custom_mouse_cursor(null)
