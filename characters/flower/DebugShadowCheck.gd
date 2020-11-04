extends Node2D

var _sun: Vector2
var _rays: = []


func _physics_process(_delta):
	if SystemSettings.get_flower_show_debug():
		show()
		update()
	else:
		hide()


func set_sun(pos: Vector2):
	_sun = pos


func add_ray_end(pos: Vector2, col: Color):
	_rays.push_back([pos, col])


func _draw():
	while not _rays.empty():
		var ray = _rays.pop_back()
		draw_line(_sun, ray[0], ray[1])
