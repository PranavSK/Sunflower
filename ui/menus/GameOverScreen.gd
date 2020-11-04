extends Control

onready var label: = $MarginContainer/VBoxContainer/Label
onready var retry_button: = $MarginContainer/VBoxContainer/RetryButton
onready var quit_button: = $MarginContainer/VBoxContainer/QuitButton
onready var showcase: = $GnomeShowcase


func _ready():
	retry_button.connect("pressed", self, "_on_retry_button_pressed")
	retry_button.connect("mouse_entered", AudioController, "play_ui_highlight_sound")
	
	quit_button.connect("pressed", self, "_on_quit_button_pressed")
	quit_button.connect("mouse_entered", AudioController, "play_ui_highlight_sound")


func _setup(value: int):
	match value:
		SceneManager.GameOver.FLOWER_DIED:
			showcase.play_defeat()
		SceneManager.GameOver.SUN_SET:
			showcase.play_defeat()
		SceneManager.GameOver.PLAYER_DIED:
			showcase.play_hurt()
		SceneManager.GameOver.FLOWER_GROWN:
			label.text = "Seized the day"
			retry_button.text = "NEXT LEVEL"
			showcase.play_victory()


func _on_retry_button_pressed():
	AudioController.play_ui_select_sound()
	SceneManager.load_stage("level0")


func _on_quit_button_pressed():
	AudioController.play_ui_cancel_sound()
	SceneManager.quit_game()
