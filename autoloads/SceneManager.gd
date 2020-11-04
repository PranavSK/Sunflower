extends Node

const TransitionFade: = preload("res://ui/helpers/TransitionFade.tscn")
const TitleScreen: = preload("res://ui/menus/TitleScreen.tscn")

const GameOverScreen: = preload("res://ui/menus/GameOverScreen.tscn")

const LEVELS_SCENE_PATHS: = {
	level0 = "res://stage/garden/Garden.tscn"
}

enum GameOver {FLOWER_GROWN, FLOWER_DIED, PLAYER_DIED, SUN_SET}

var enable_both_directions: = false
var skill_level: = 0.0

var _loader: QueueLoader

func _ready():
	_loader = QueueLoader.new()
	add_child(_loader)
	
	SignalBus.connect("player_died", self, "load_game_over_screen", [GameOver.PLAYER_DIED])
	SignalBus.connect("flower_died", self, "load_game_over_screen", [GameOver.FLOWER_DIED])
	SignalBus.connect("day_completed", self, "load_game_over_screen", [GameOver.SUN_SET])
	SignalBus.connect("flower_grown", self, "load_game_over_screen", [GameOver.FLOWER_GROWN])


func load_title_screen():
	change_scene_to(TitleScreen)
	AudioController.fade_to_menu()


func load_game_over_screen(game_over_state: int):
	SignalBus.emit_signal("stage_end")
	if game_over_state == GameOver.FLOWER_GROWN:
		skill_level += 0.2
	change_scene_to(GameOverScreen, [game_over_state])
	AudioController.fade_to_menu()


func load_stage(level: String):
	change_scene_to(_loader.get_resource(level))
	AudioController.fade_to_gamplay()


func initialize_stages():
	for level in LEVELS_SCENE_PATHS:
		_loader.queue(level, LEVELS_SCENE_PATHS[level])
	
	yield(_loader, "queue_finished")


func change_scene_to(packed_scene: PackedScene, params: = []) -> void:
	"""
	Play a fade out transition and change scene to the given `packed_scene`.
	After scene change, before fade in transition, the `callback_method` is 
	called on the new scene with `callback_args` as args.
	"""	
	var transtion_fade_instance: = TransitionFade.instance()
	add_child(transtion_fade_instance)
	transtion_fade_instance.play_backwards("fade")
	yield(transtion_fade_instance, "animation_finished")
	
	var scene = get_tree().current_scene
	if scene.has_method("_teardown"):
		var state = scene.callv("_teardown")
		if state and state is GDScriptFunctionState:
			yield(state, "completed")
	
	get_tree().change_scene_to(packed_scene)
	yield(get_tree(), "idle_frame")
	
	scene = get_tree().current_scene
	if scene.has_method("_setup"):
		var state = scene.callv("_setup", params)
		if state and state is GDScriptFunctionState:
			yield(state, "completed")
	
	transtion_fade_instance.play("fade")
	yield(transtion_fade_instance, "animation_finished")
	transtion_fade_instance.queue_free()


func quit_game():
	if not OS.get_name() == "HTML5":
		get_tree().quit()
