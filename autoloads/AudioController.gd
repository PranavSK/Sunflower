extends Node2D

onready var _select_player: = $UISelectPlayer
onready var _highlight_player: = $UIHighlightPlayer
onready var _cancel_player: = $UICancelPlayer

onready var _gameplay_player: = $GameplayMusicPlayer
onready var _menu_player: = $MenuMusicPlayer
onready var _fade_animator: = $AnimationPlayer


func _ready():
	_fade_animator.connect("animation_finished", self, "_on_fade_finished")


func play_ui_select_sound():
	_select_player.play()


func play_ui_highlight_sound():
	_highlight_player.play()


func play_ui_cancel_sound():
	_cancel_player.play()


func fade_to_gamplay():
	if _gameplay_player.playing:
		return
	
	_gameplay_player.play()
	_fade_animator.play("fade_to_gameplay")


func fade_to_menu():
	if _menu_player.playing:
		return
	
	_menu_player.play()
	_fade_animator.play("fade_to_menu")


func _on_fade_finished(anim):
	if anim == "fade_to_gameplay":
		_menu_player.stop()
	if anim == "fade_to_menu":
		_gameplay_player.stop()
