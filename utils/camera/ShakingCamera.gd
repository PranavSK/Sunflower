extends Camera2D

onready var timer: = $Timer
onready var chromatic_aberration: = $ScreenFXLayer/ChromaticAberration

export var amplitude: = 6.0
export var duration: = 0.8 setget set_duration
export(float, EASE) var DAMP_EASING: = 1.0
export var shake: = false setget set_shake


func _ready() -> void:
	randomize()
	set_process(false)
	self.duration = duration
	SignalBus.connect("camera_shake_requested", self, "_on_camera_shake_requested")


func _process(_delta: float) -> void:
	var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping
	)
	chromatic_aberration.material.set_shader_param("amount", offset)


func _on_ShakeTimer_timeout() -> void:
	self.shake = false


func _on_camera_shake_requested() -> void:
	self.shake = true


func set_duration(value: float) -> void:
	if not is_inside_tree():
		return
	duration = value
	timer.wait_time = duration


func set_shake(value: bool) -> void:
	if not is_inside_tree():
		return
	shake = value
	set_process(shake)
	
	offset = Vector2()
	if shake:
		chromatic_aberration.show()
		timer.start()
	else:
		chromatic_aberration.hide()
