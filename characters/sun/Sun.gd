extends Light2D

onready var _anim_player: = $AnimationPlayer


func _ready():
	SignalBus.connect("stage_start", self, "_on_stage_start")
	SignalBus.connect("stage_end", self, "_on_stage_end")


func _on_stage_start():
	_anim_player.play("sun_motion", -1, SystemSettings.get_sun_day_scale())
	
	yield(_anim_player, "animation_finished")
	SignalBus.emit_signal("day_completed")


func _on_stage_end():
	_anim_player.stop()
