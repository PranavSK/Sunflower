extends Node2D

onready var _muzzle: = $Muzzle
onready var _anim_sprite: = $AnimatedSprite
onready var _fire_delay_timer: = $FireDelayTimer
onready var _fire_sound_player: = $FireSoundPlayer

const FIRE_ANIM_NAME: = "fire"
const IDLE_ANIM_NAME: = "idle"

export(PackedScene) var projectile: PackedScene

var world

var _is_firing: = false


func _ready():
	_fire_delay_timer.connect("timeout", self, "_on_fire_delay_timeout")
	_anim_sprite.connect("animation_finished", self, "_on_animation_completed")


func fire():
	if _is_firing:
		return
	
	if not projectile:
		push_error("A valid projectile scene is not available to fire.")
	
	_is_firing = true
	
	var new_projectile = projectile.instance()
	new_projectile.global_transform = _muzzle.global_transform
	var projectile_dir = world.to_local((_muzzle.global_position - global_position).normalized())
	new_projectile.setup(SystemSettings.get_gnome_shell_launch_speed() * projectile_dir, SystemSettings.get_gnome_shell_max_height())
	world.add_child(new_projectile)
	
	_anim_sprite.play(FIRE_ANIM_NAME)
	_fire_sound_player.play()
	_fire_delay_timer.start(SystemSettings.get_gnome_fire_cooldown())


func _on_fire_delay_timeout():
	_is_firing = false


func _on_animation_completed():
	_anim_sprite.animation = IDLE_ANIM_NAME
