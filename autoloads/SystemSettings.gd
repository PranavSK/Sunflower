extends Node


func set_sun_day_scale(value):
	_set_system_param("sun/day_scale", value)


func get_sun_day_scale():
	return _get_system_param("sun/day_scale")


func set_flower_growth_rate(value):
	_set_system_param("flower/growth_rate", value)


func get_flower_growth_rate():
	return _get_system_param("flower/growth_rate")


func set_flower_sad_timeout(value):
	_set_system_param("flower/sad_timeout", value)


func get_flower_sad_timeout():
	return _get_system_param("flower/sad_timeout")


func set_flower_show_debug(value):
	SettingsManager.set_value("user", "debug/show_debug", value)


func get_flower_show_debug():
	return SettingsManager.get_value("user", "debug/show_debug", false) if OS.is_debug_build() else false


func set_gnome_shell_launch_speed(value):
	_set_system_param("gnome/shell/launch_speed", value)


func get_gnome_shell_launch_speed():
	return _get_system_param("gnome/shell/launch_speed")


func set_gnome_shell_max_height(value):
	_set_system_param("gnome/shell/max_height", value)


func get_gnome_shell_max_height():
	return _get_system_param("gnome/shell/max_height")


func set_gnome_fire_cooldown(value):
	_set_system_param("gnome/shell/fire_cooldown", value)


func get_gnome_fire_cooldown():
	return _get_system_param("gnome/shell/fire_cooldown")


func set_factory_max_alive_blockers(value):
	_set_system_param("blocker_factory/max_alive_blockers", value)


func get_factory_max_alive_blockers():
	return _get_system_param("blocker_factory/max_alive_blockers")


func set_factory_blocker_config(name, config):
	_set_system_param("blocker_factory/" + name, config)


func get_factory_blocker_config(name):
	return _get_system_param("blocker_factory/" + name)


func _set_system_param(path, value):
	var difficulty = SettingsManager.get_value("user", "game/difficulty")
	SettingsManager.set_value("system", "game/" + difficulty + "/" + path, value)


func _get_system_param(path):
	var difficulty = SettingsManager.get_value("user", "game/difficulty")
	return SettingsManager.get_value("system", "game/" + difficulty + "/" + path)
