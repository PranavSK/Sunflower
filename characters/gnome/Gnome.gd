extends KinematicBody2D

onready var _gun_holder: = $GunHolder
onready var _sprite: = $Sprite
onready var _move_sound_player: = $MoveSoundPlayer

const MOVE_SPEED: = 300
const ACCEL: = 10
const UP_VECTOR: = Vector2.UP
const GRAVITY: = 500 * Vector2.DOWN
const SNAP_VECTOR: = 10 * Vector2.DOWN
const KNOCKBACK: = 50

const SpawnTween: = preload("res://utils/spawn_fx/SpawnTween.tscn")

var _velocity: = Vector2.ZERO
var _gun: Node2D


func _ready():
	# Set up available guns to allow switching.
	# Set the gun at 0 as initial gun
	_switch_gun(0)
	hide()
	set_process(false)
	set_physics_process(false)
	SignalBus.connect("stage_start", self, "_on_stage_start")
	SignalBus.connect("stage_end", self, "_on_stage_end")


func _process(delta):
	_gun_holder.look_at(get_global_mouse_position())
	
	var target_velocity = Vector2.ZERO
	
	if not is_on_floor():
		target_velocity = GRAVITY
	else:
		var dir = Input.get_action_strength("move_right") * Vector2.RIGHT\
				+ Input.get_action_strength("move_left") * Vector2.LEFT
		target_velocity = dir * MOVE_SPEED
		
		if dir.is_equal_approx(Vector2.ZERO):
			_move_sound_player.stop()
		elif not _move_sound_player.playing:
			_move_sound_player.play()
		
		if Input.is_action_just_pressed("move_left"):
			_sprite.flip_h = true
		
		if Input.is_action_just_pressed("move_right"):
			_sprite.flip_h = false
		
	if Input.is_action_just_pressed("fire"):
		_gun.fire()
		_velocity += (KNOCKBACK * Vector2.LEFT).rotated(_gun_holder.rotation)
	
	_velocity = lerp(_velocity, target_velocity, delta * ACCEL)


func _physics_process(_delta):
	_velocity = move_and_slide_with_snap(_velocity, SNAP_VECTOR, UP_VECTOR)


func damage():
	SignalBus.emit_signal("player_died")


func _switch_gun(index: int) -> void:
	var gun_count = _gun_holder.get_child_count()
	if index < 0 or index >= gun_count:
		push_error("Invalid index requested for gun switching.")
	_gun = null
	
	for i in _gun_holder.get_child_count():
		if i == index:
			_gun = _gun_holder.get_child(i)
			_gun.show()
			_gun.world = get_parent()
		else:
			_gun_holder.get_child(i).hide()


func _on_stage_start():
	set_process(true)
	set_physics_process(true)
	add_child(SpawnTween.instance())
	show()


func _on_stage_end():
	set_process(false)
	set_physics_process(false)
