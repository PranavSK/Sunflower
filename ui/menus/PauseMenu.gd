extends Popup

onready var _resume_button: = $MarginContainer/Buttons/SettingsContainer/Buttons/BackButton
onready var _main_menu_btn: = $MarginContainer/Buttons/MainMenu
onready var _quit_button: = $MarginContainer/Buttons/Quit


func _ready():
	_resume_button.connect("pressed", self, "_on_resume_button_pressed")
	_resume_button.connect("mouse_entered", AudioController, "play_ui_highlight_sound")
	_main_menu_btn.connect("pressed", self, "_on_main_menu_button_pressed")
	_main_menu_btn.connect("mouse_entered", AudioController, "play_ui_highlight_sound")
	_quit_button.connect("pressed", self, "_on_quit_button_pressed")
	_quit_button.connect("mouse_entered", AudioController, "play_ui_highlight_sound")
	
	connect("about_to_show", self, "_on_popup_about_to_show")
	connect("popup_hide", self, "_on_popup_hide")


func _on_popup_about_to_show():
	get_tree().paused = true


func _on_popup_hide():
	get_tree().paused = false


func _on_resume_button_pressed():
	AudioController.play_ui_select_sound()
	hide()


func _on_main_menu_button_pressed():
	AudioController.play_ui_select_sound()
	SceneManager.load_title_screen()


func _on_quit_button_pressed():
	AudioController.play_ui_cancel_sound()
	SceneManager.quit_game()
