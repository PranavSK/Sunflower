extends MarginContainer

onready var _fullscreen_btn: = $Buttons/Fullscreen
onready var _music_volume: = $Buttons/Music/Volume
onready var _sfx_volume: = $Buttons/SFX/Volume
onready var _master_volume: = $Buttons/Master/Volume


func _ready():
	_fullscreen_btn.pressed = ProjectSettings.get_setting("display/window/size/fullscreen")
	OS.window_fullscreen = _fullscreen_btn.pressed

	_music_volume.value = SettingsManager.get_value("user", "audio/background.volume")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Background"), linear2db(_music_volume.value / 100.0))

	
	_sfx_volume.value = SettingsManager.get_value("user", "audio/sfx.volume")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(_sfx_volume.value / 100.0))

	
	_master_volume.value = SettingsManager.get_value("user", "audio/master.volume")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(_master_volume.value / 100.0))
	
	_fullscreen_btn.connect("toggled", self, "_on_fullscreen_toggled")
	_music_volume.connect("value_changed", self, "_on_music_volume_changed")
	_sfx_volume.connect("value_changed", self, "_on_sfx_volume_changed")
	_master_volume.connect("value_changed", self, "_on_master_volume_changed")


func _on_fullscreen_toggled(value):
	OS.window_fullscreen = value
	ProjectSettings.set_setting("display/window/size/fullscreen", value)


func _on_music_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Background"), linear2db(value / 100.0))
	SettingsManager.set_value("user", "audio/background.volume", value)


func _on_sfx_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value / 100.0))
	SettingsManager.set_value("user", "audio/sfx.volume", value)


func _on_master_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value / 100.0))
	SettingsManager.set_value("user", "audio/master.volume", value)
