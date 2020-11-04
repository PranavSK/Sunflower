extends Blocker

onready var _sprite: = $Sprite

var _rng: RandomNumberGenerator


func _ready():
	_rng = RandomNumberGenerator.new()
	_rng.randomize()
	_sprite.self_modulate = get_random_pastel_color()


func get_random_pastel_color() -> Color:
	return Color8(
		round(randf() * 127) + 127,
		round(randf() * 127) + 127,
		round(randf() * 127) + 127
	)
