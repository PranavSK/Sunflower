extends PathFollow2D
class_name Blocker

onready var _path_animator: = $PathAnimator

signal damaged


func _ready():
	SignalBus.connect("stage_end", self, "_on_stage_end")


func start_pathing(speed):
	_path_animator.play("path_follow", -1, speed)


func _on_stage_end():
	_path_animator.stop()
