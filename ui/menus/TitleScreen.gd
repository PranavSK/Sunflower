extends Control

onready var _play_btn: = $Margin/Content/Body/HomeContainer/Buttons/Play
onready var _settings_btn: = $Margin/Content/Body/HomeContainer/Buttons/Settings
onready var _credits_btn: = $Margin/Content/Body/HomeContainer/Buttons/Credits
onready var _quit_btn: = $Margin/Content/Body/HomeContainer/Buttons/Quit

onready var _back_btn: = $Margin/Content/Body/CreditsContainer/VBoxContainer/BackButton
onready var _bb_label: = $Margin/Content/Body/CreditsContainer/VBoxContainer/RichTextLabel

onready var _back_btn_settings: = $Margin/Content/Body/SettingsContainer/Buttons/BackButton

onready var _normal_btn: = $Margin/Content/Body/HomeContainer/Buttons/DifficultyOptions/Normal
onready var _hard_btn: = $Margin/Content/Body/HomeContainer/Buttons/DifficultyOptions/Hard
onready var _extreme_btn: = $Margin/Content/Body/HomeContainer/Buttons/DifficultyOptions/Extreme

onready var _home: = $Margin/Content/Body/HomeContainer
onready var _credits: = $Margin/Content/Body/CreditsContainer
onready var _settings: = $Margin/Content/Body/SettingsContainer


func _ready():
	_play_btn.connect("pressed", self, "_on_play_button_pressed")
	_settings_btn.connect("pressed", self, "_on_settings_button_pressed")
	_credits_btn.connect("pressed", self, "_on_credits_button_pressed")
	_play_btn.connect("mouse_entered", AudioController, "play_ui_highlight_sound")
	_settings_btn.connect("mouse_entered", AudioController, "play_ui_highlight_sound")
	_credits_btn.connect("mouse_entered", AudioController, "play_ui_highlight_sound")

	_quit_btn.connect("pressed", self, "_on_quit_button_pressed")
	_quit_btn.connect("mouse_entered", AudioController, "play_ui_highlight_sound")
	
	_back_btn.connect("pressed", self, "_on_back_button_pressed")
	_back_btn.connect("mouse_entered", AudioController, "play_ui_highlight_sound")
	
	_back_btn_settings.connect("pressed", self, "_on_back_button_pressed")
	_back_btn_settings.connect("mouse_entered", AudioController, "play_ui_highlight_sound")
	
	_normal_btn.connect("pressed", SettingsManager, "set_value", ["user", "game/difficulty", "normal"])
	_hard_btn.connect("pressed", SettingsManager, "set_value", ["user", "game/difficulty", "hard"])
	_extreme_btn.connect("pressed", SettingsManager, "set_value", ["user", "game/difficulty", "extreme"])
	
	_bb_label.connect("meta_clicked", self, "_on_bb_label_meta_clicked")


func _on_bb_label_meta_clicked(meta):
	OS.shell_open(meta)


func _on_back_button_pressed():
	AudioController.play_ui_cancel_sound()
	_home.show()
	_credits.hide()
	_settings.hide()


func _on_play_button_pressed():
	AudioController.play_ui_select_sound()
	SceneManager.load_stage("level0")


func _on_settings_button_pressed():
	AudioController.play_ui_select_sound()
	_credits.hide()
	_home.hide()
	_settings.show()


func _on_credits_button_pressed():
	AudioController.play_ui_select_sound()
	_credits.show()
	_home.hide()
	_settings.hide()


func _on_quit_button_pressed():
	AudioController.play_ui_cancel_sound()
	SceneManager.quit_game()
