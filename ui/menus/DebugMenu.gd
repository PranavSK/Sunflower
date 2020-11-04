extends PopupPanel

onready var _sun_day_scale: = $ScrollContainer/VBoxContainer/SunDayScale/SpinBox
onready var _flower_growth_rate: = $ScrollContainer/VBoxContainer/FlowerGrowthRate/SpinBox
onready var _flower_sad_timeout: = $ScrollContainer/VBoxContainer/FlowerSadTimeout/SpinBox
onready var _flower_show_debug: = $ScrollContainer/VBoxContainer/FlowerShowDebug
onready var _gnome_shell_launch_speed: = $ScrollContainer/VBoxContainer/GnomeProjectileLaunchSpeed/SpinBox
onready var _gnome_shell_max_height: = $ScrollContainer/VBoxContainer/GnomeProjectileMaxDistance/SpinBox
onready var _gnome_fire_cooldown: = $ScrollContainer/VBoxContainer/GnomeFireDelay/SpinBox
onready var _max_blockers: = $ScrollContainer/VBoxContainer/BlockerMaxAlive/SpinBox
onready var _blocker_type: = $ScrollContainer/VBoxContainer/BlockerType
onready var _blocker_json: = $ScrollContainer/VBoxContainer/BlockerConfigJSON


func _ready():
	connect("about_to_show", self, "_on_popup_about_to_show")
	connect("popup_hide", self, "_on_popup_hide")
	
	_sun_day_scale.value = SystemSettings.get_sun_day_scale()
	_flower_growth_rate.value = SystemSettings.get_flower_growth_rate()
	_flower_sad_timeout.value = SystemSettings.get_flower_sad_timeout()
	_flower_show_debug.pressed = SystemSettings.get_flower_show_debug()
	_gnome_shell_launch_speed.value = SystemSettings.get_gnome_shell_launch_speed()
	_gnome_shell_max_height.value = SystemSettings.get_gnome_shell_max_height()
	_gnome_fire_cooldown.value = SystemSettings.get_gnome_fire_cooldown()
	_max_blockers.value = SystemSettings.get_factory_max_alive_blockers()
	
	_sun_day_scale.connect("value_changed", SystemSettings, "set_sun_day_scale(value)")
	_flower_growth_rate.connect("value_changed", SystemSettings, "set_flower_growth_rate")
	_flower_sad_timeout.connect("value_changed", SystemSettings, "set_flower_sad_timeout")
	_flower_show_debug.connect("toggled", SystemSettings, "set_flower_show_debug")
	_gnome_shell_launch_speed.connect("value_changed", SystemSettings, "set_gnome_shell_launch_speed")
	_gnome_shell_max_height.connect("value_changed", SystemSettings, "set_gnome_shell_max_height")
	_gnome_fire_cooldown.connect("value_changed", SystemSettings, "set_gnome_fire_cooldown")
	_max_blockers.connect("value_changed", SystemSettings, "set_factory_max_alive_blockers")
	_blocker_type.connect("item_selected", self, "_on_blocker_type_selected")
	_blocker_json.connect("text_changed", self, "_on_blocker_config_changed")


func _input(event):
	if visible and event.is_action_pressed("ui_end"):
		hide()
		get_tree().set_input_as_handled()


func _on_popup_about_to_show():
	get_tree().paused = true


func _on_popup_hide():
	get_tree().paused = false


func _on_blocker_type_selected(idx):
	match idx:
		0:
			_blocker_json.text = to_json(SystemSettings.get_factory_blocker_config("aeroplane"))
		1:
			_blocker_json.text = to_json(SystemSettings.get_factory_blocker_config("balloon"))
		2:
			_blocker_json.text = to_json(SystemSettings.get_factory_blocker_config("bird"))
		3:
			_blocker_json.text = to_json(SystemSettings.get_factory_blocker_config("spaceship"))
		4:
			_blocker_json.text = to_json(SystemSettings.get_factory_blocker_config("tortoise"))


func _on_blocker_config_changed():
	match _blocker_type.selected:
		0:
			SystemSettings.set_factory_blocker_config("aeroplane", JSON.parse(_blocker_json.text).result)
		1:
			SystemSettings.set_factory_blocker_config("balloon", JSON.parse(_blocker_json.text).result)
		2:
			SystemSettings.set_factory_blocker_config("bird", JSON.parse(_blocker_json.text).result)
		3:
			SystemSettings.set_factory_blocker_config("spaceship", JSON.parse(_blocker_json.text).result)
		4:
			SystemSettings.set_factory_blocker_config("tortoise", JSON.parse(_blocker_json.text).result)
