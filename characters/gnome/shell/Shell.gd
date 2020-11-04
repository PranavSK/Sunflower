extends Area2D

onready var _timer: = $LifetimeTimer
onready var _delay_trigger_timer: = $DelayTriggerTimer
onready var _visible_notifier: = $VisibilityNotifier2D
onready var _explode_pos: = $ExplosionSpawnPoint

const TRIGGER_DELAY: = 0.05 # secs to wait before exploding. This prevents exploding at source.

export var lifetime: = 10.0
export(PackedScene) var explosion: PackedScene

var _velocity: = Vector2.ZERO
var _gravity: = Vector2.DOWN


func _ready():
	connect("area_entered", self, "_on_Grenade_area_entered")
	connect("body_entered", self, "_on_Grenade_body_entered")
	_visible_notifier.connect("screen_exited", self, "_on_screen_exited")
	_timer.start(lifetime)
	_delay_trigger_timer.start(TRIGGER_DELAY)
	yield(_timer, "timeout")
	_explode()


func _physics_process(delta):
	_velocity += _gravity * delta
	var displacement = _velocity * delta
	look_at(position + displacement)
	translate(displacement)


func setup(initial_velocity: Vector2, max_distance: float):
	_velocity = initial_velocity
	_gravity = (initial_velocity.length_squared() / (2 * max_distance)) * Vector2.DOWN


func _explode():
	var new_explosion = explosion.instance()
	new_explosion.global_position = _explode_pos.global_position
	# This function could be called from the physics thread. Hence defer
	# scene tree changes.
	get_parent().call_deferred("add_child", new_explosion)
	queue_free()


func _on_Grenade_area_entered(area):
	if not _delay_trigger_timer.is_stopped():
		return
	_explode()


func _on_Grenade_body_entered(body):
	if not _delay_trigger_timer.is_stopped():
		return
	_explode()


func _on_screen_exited():
	_timer.stop()
	queue_free()
