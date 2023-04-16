extends Node2D

signal resolve_round_actions
signal new_round
signal game_over

const TURN_NUMBER_FINAL = 4
const TURN_MOON_PHASES = [
	GlobalConstants.MoonPhases.CRESCENT,
	GlobalConstants.MoonPhases.HALF,
	GlobalConstants.MoonPhases.FULL,
	GlobalConstants.MoonPhases.HALF,
	GlobalConstants.MoonPhases.CRESCENT,
]
var turn_number = 0
var game_is_over = false

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

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and game_is_over:
		get_tree().change_scene_to_file("res://gameplay/test_scene.tscn")

func _on_timer_timeout():
	if !game_is_over:
		emit_signal("resolve_round_actions", [0, 1], [$Player1, $Player2], [$Player1/ControlPalette.current_action, $Player2/ControlPalette.current_action], TURN_MOON_PHASES[turn_number])
		
		game_is_over = _check_game_over()
		if !game_is_over:
			turn_number = (turn_number + 1) 
			emit_signal("new_round", turn_number, TURN_MOON_PHASES[turn_number])
		else:
			emit_signal("game_over")
	

func _check_game_over():
	return $Player1.health <= 0 or $Player2.health <=0 or turn_number == TURN_NUMBER_FINAL
