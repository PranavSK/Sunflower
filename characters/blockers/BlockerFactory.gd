extends Node2D

const BLOCKERS = {
	aeroplane = {
		blocker_prefab = preload("res://characters/blockers/aeroplane/Aeroplane.tscn"),
		blocker_path = preload("res://characters/blockers/aeroplane/AeroplanePath.tscn")
	},
	balloon = {
		blocker_prefab = preload("res://characters/blockers/balloon/Balloon.tscn"),
		blocker_path = preload("res://characters/blockers/balloon/BalloonPath.tscn")
	},
	bird = {
		blocker_prefab = preload("res://characters/blockers/bird/Bird.tscn"),
		blocker_path = preload("res://characters/blockers/bird/BirdPath.tscn")
	},
	spaceship = {
		blocker_prefab = preload("res://characters/blockers/spaceship/Spaceship.tscn"),
		blocker_path = preload("res://characters/blockers/spaceship/SpaceshipPath.tscn")
	},
	tortoise = {
		blocker_prefab = preload("res://characters/blockers/tortoise/Tortoise.tscn"),
		blocker_path = preload("res://characters/blockers/tortoise/TortoisePath.tscn")
	}
}

var _available_blockers: = []
var _rng: RandomNumberGenerator
var _spawn_timers: = {}


func _ready():
	# On every load have different seed
	_rng = RandomNumberGenerator.new()
	_rng.randomize()
	
	
	for blocker_type in BLOCKERS:
		var timer = Timer.new()
		timer.one_shot = true
		timer.connect("timeout", self, "_on_spawn_timeout", [blocker_type])
		$Timers.add_child(timer)
		_spawn_timers[blocker_type] = timer
	
	_available_blockers = BLOCKERS.keys()
	
	_update_available_blockers()
	
	SignalBus.connect("skill_level_changed", self, "_on_skill_level_changed")
	SignalBus.connect("blocker_spawn_requested", self, "_on_blocker_spawn_requested")


func _on_blocker_spawn_requested():
	var alive_count = get_child_count() - 1 # The Timers node is not considered
	if alive_count >= SystemSettings.get_factory_max_alive_blockers():
		return
	
	var blocker_type = _available_blockers.pop_front()
	if not blocker_type:
		return
	
	var config = SystemSettings.get_factory_blocker_config(blocker_type)
	var height = _rng.randfn(config.spawn_height, config.spawn_height_deviation)
	var path = BLOCKERS[blocker_type].blocker_path.instance()
	var blocker: Blocker = BLOCKERS[blocker_type].blocker_prefab.instance()
	path.add_child(blocker)
	blocker.connect("damaged", path, "queue_free")
	
	var is_reversed: = false
	if SceneManager.enable_both_directions:
		is_reversed = bool(randi() % 2)
	
	if is_reversed:
		# The sun starts from the right - hence the opp direction is correct.
		# Along the sun rise is reversed.
		path.position = Vector2(ProjectSettings.get_setting("display/window/size/width"), height)
		path.scale.x *= -1
	else:
		path.position = Vector2(0,height)
	
	add_child(path)
	blocker.start_pathing(config.default_speed / 100.0)
	_spawn_timers[blocker_type].start(config.spawn_timeout)


func _on_spawn_timeout(blocker_type):
	_make_available(blocker_type)


func _update_available_blockers():
	var copy = _available_blockers.duplicate()
	_available_blockers.clear()
	for blocker_type in copy:
		_make_available(blocker_type)


func _make_available(blocker_type):
	var config = SystemSettings.get_factory_blocker_config(blocker_type)
	if SceneManager.skill_level >= config.skill_level_threshold:
		_available_blockers.push_back(blocker_type)
