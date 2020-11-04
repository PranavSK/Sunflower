extends Area2D

onready var _timer: = $Timer
onready var _anim_sprite: = $AnimatedSprite
onready var _explosion_sound_player: = $ExplosionSoundPlayer

export var lifetime: = 0.7


func _ready():
	connect("area_entered", self, "_damage_object")
	connect("body_entered", self, "_damage_object")
	_timer.connect("timeout", self, "_on_timer_timeout")
	_anim_sprite.connect("animation_finished", self, "_on_animation_finished")
	_explosion_sound_player.connect("finished", self, "_on_explosion_sound_finished")
	
	_anim_sprite.play()
	SignalBus.emit_signal("camera_shake_requested")
	
	_timer.start(lifetime)
	_explosion_sound_player.play()


func _damage_object(obj):
	if obj.has_method("damage"):
		obj.damage()
	else:
		push_warning("Explosion detected Object! No damage() method found!!")


func _on_animation_finished():
	_anim_sprite.hide()
	_cleanup()


func _on_explosion_sound_finished():
	_cleanup()


func _on_timer_timeout():
	monitoring = false
	_cleanup()


func _cleanup():
	if _timer.is_stopped() and not _anim_sprite.playing and not _explosion_sound_player.playing:
		queue_free()
