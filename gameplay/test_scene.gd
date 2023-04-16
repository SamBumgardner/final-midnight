extends Node2D

signal resolve_round_actions
signal new_round
signal game_over

const TURN_NUMBER_FINAL = 5
const TURN_MOON_PHASES = [
	GlobalConstants.MoonPhases.CRESCENT,
	GlobalConstants.MoonPhases.HALF,
	GlobalConstants.MoonPhases.FULL,
	GlobalConstants.MoonPhases.HALF,
	GlobalConstants.MoonPhases.CRESCENT,
]
var turn_number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("resolve_round_actions", $Player1._on_resolve_round_actions)
	connect("resolve_round_actions", $Player2._on_resolve_round_actions)
	connect("new_round", $Player1/ControlPalette._on_new_round)
	connect("new_round", $Player2/ControlPalette._on_new_round)
	connect("game_over", $Player1/ControlPalette._on_game_over)
	connect("game_over", $Player2/ControlPalette._on_game_over)
	connect("new_round", $Hud._on_new_round)
	connect("game_over", $Hud._on_game_over)
	
	emit_signal("new_round", turn_number, TURN_MOON_PHASES[turn_number])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("resolve_round_actions", [0, 1], [$Player1, $Player2], [$Player1/ControlPalette.current_action, $Player2/ControlPalette.current_action], TURN_MOON_PHASES[turn_number])
		if(_check_game_over()):
			emit_signal("game_over")
		turn_number = (turn_number + 1) % 5
		emit_signal("new_round", turn_number, TURN_MOON_PHASES[turn_number])

func _check_game_over():
	return $Player1.health <= 0 or $Player2.health <=0
	
