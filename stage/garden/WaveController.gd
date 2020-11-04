extends Node

onready var timer: = $Timer


func _ready():
	timer.connect("timeout", self, "_on_spawn_timeout")
	timer.start(0.5)


func _on_spawn_timeout():
	SignalBus.emit_signal("blocker_spawn_requested")
