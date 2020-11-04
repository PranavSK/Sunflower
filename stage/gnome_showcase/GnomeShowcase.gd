extends ViewportContainer

onready var _player: = $World/gnome/AnimationPlayer


func play_defeat():
	_player.play("Defeat-loop")


func play_victory():
	_player.play("Victory-loop")


func play_hurt():
	_player.play("Hurt-loop")
