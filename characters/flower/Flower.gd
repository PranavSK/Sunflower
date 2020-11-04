extends Area2D

onready var _anim_player: = $AnimationPlayer
onready var _sad_timer: = $SadTimer
onready var _shape: = $CollisionShape2D
onready var _sun: = get_node_or_null(sun_node)
onready var _debug_shadow_check: = $DebugLayer/ShadowCheck

enum State {HAPPY, GROW, SAD, CRY}
const CHECK_HEIGHT_STEP: = 25

export(NodePath) var sun_node
export var flicker_rate: = 4
export(int, LAYERS_2D_PHYSICS) var blocker_layer: = 1

var _state: int = State.HAPPY
var _growth: = 0


func _ready():
	_anim_player.connect("animation_finished", self, "_on_animation_finished")
	_sad_timer.connect("timeout", self, "_on_sad_timeout")
	
	_anim_player.play("happy", -1, SystemSettings.get_flower_growth_rate())
	
	if not SystemSettings.get_flower_show_debug():
		_debug_shadow_check.hide()


func _physics_process(delta):
	if not _sun:
		print_debug("No Sun found!")
		return
	
	_check_blocked()


func damage():
	if _state == State.GROW:
		yield(_anim_player, "animation_finished")
	_change_to_cry()


func _check_blocked():
	var sun_pos = _sun.global_position
	var shape_extent_y = _shape.shape.extents.y
	var shape_extent_x = _shape.shape.extents.x
	var flower_top_pos = _shape.global_position + Vector2(0, shape_extent_y)
	var flower_bottom_pos = _shape.global_position - Vector2(0, shape_extent_y)
	
	var height = shape_extent_y * 2
	var num_rays = floor(height / CHECK_HEIGHT_STEP)
	
	var is_blocked: = false
	for ind in num_rays:
		is_blocked = is_blocked or\
				_check_ray_blocked(flower_top_pos - Vector2(shape_extent_x, ind * CHECK_HEIGHT_STEP)) or\
				_check_ray_blocked(flower_top_pos - Vector2(-shape_extent_x, ind * CHECK_HEIGHT_STEP))
		if is_blocked:
			break
	if not is_blocked:
		is_blocked =is_blocked or\
				_check_ray_blocked(flower_bottom_pos - Vector2(shape_extent_x, 0)) or\
				_check_ray_blocked(flower_bottom_pos - Vector2(-shape_extent_x, 0))
	
	if SystemSettings.get_flower_show_debug():
		_debug_shadow_check.set_sun(sun_pos)
	
	_set_blocked(is_blocked)


func _check_ray_blocked(to: Vector2):
	var from = _sun.global_position
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(from, to, [], blocker_layer, false, true)
	
	if SystemSettings.get_flower_show_debug():
		_debug_shadow_check.add_ray_end(
			result.position if not result.empty() else to,
			Color.red if not result.empty() and result.collider != self else Color.green
		)
	
	return (not result.empty() and result.collider != self)


func _set_blocked(value: bool):
	if value and _state == State.HAPPY:
		_change_to_sad()
	elif not value and _state == State.SAD:
		_change_to_happy()


func _change_to_happy():
	if _state == State.HAPPY:
		return
	_sad_timer.stop()
	_anim_player.play("happy", -1, SystemSettings.get_flower_growth_rate())
	_state = State.HAPPY


func _change_to_grow():
	if _state == State.GROW:
		return
	_growth += 1
	if _growth > 5:
		return
	if _growth == 5:
		SignalBus.emit_signal("flower_grown")
		
	_anim_player.play("grow_stage_" + str(_growth))
	_state = State.GROW


func _change_to_sad():
	if _state == State.SAD:
		return
	_anim_player.play("sad", -1, flicker_rate)
	_sad_timer.start(SystemSettings.get_flower_sad_timeout())
	_state = State.SAD


func _change_to_cry():
	if _state == State.CRY:
		return
	_sad_timer.stop()
	_anim_player.play("cry")
	_state = State.CRY
	yield(_anim_player, "animation_finished")
	SignalBus.emit_signal("flower_died")


func _on_sad_timeout():
	_change_to_cry()


func _on_animation_finished(anim: String):
	if anim == "happy":
		_change_to_grow()
	elif anim.begins_with("grow"):
		_change_to_happy()
