extends Control


func _ready():
	yield(SceneManager.initialize_stages(), "completed")
	SceneManager.load_title_screen()
