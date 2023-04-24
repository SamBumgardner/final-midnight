extends Node2D

class_name NetworkedGameplay

signal resolve_round_actions
signal new_round
signal game_over

var p1_network_id = 1
var p2_network_id = 1

var p1_action_history = []
var p2_action_history = []

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
	$Player1.set_multiplayer_authority(p1_network_id)
	$Player2.set_multiplayer_authority(p2_network_id)
	
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
		restart_game.rpc()
	
	if !game_is_over && p1_action_history.size() > turn_number && p2_action_history.size() > turn_number:
		emit_signal("resolve_round_actions", [0, 1], [$Player1, $Player2], [p1_action_history[turn_number], p2_action_history[turn_number]], TURN_MOON_PHASES[turn_number])
		
		game_is_over = _check_game_over()
		if !game_is_over:
			turn_number = (turn_number + 1) 
			emit_signal("new_round", turn_number, TURN_MOON_PHASES[turn_number])
		else:
			emit_signal("game_over")

func _on_timer_timeout():
	if $Player1.is_multiplayer_authority():
		commit_action.rpc($Player1.player_number, $Player1.get_multiplayer_authority(), $Player1.get_current_action())
	if $Player2.is_multiplayer_authority():
		commit_action.rpc($Player2.player_number, $Player2.get_multiplayer_authority(), $Player2.get_current_action())

func _check_game_over():
	return $Player1.health <= 0 or $Player2.health <=0 or turn_number == TURN_NUMBER_FINAL

@rpc("any_peer", "call_local")
func commit_action(player_number, player_id, action):
	if player_number == GlobalConstants.Players.FIRST && player_id == p1_network_id:
		p1_action_history.push_back(action)
	elif player_number == GlobalConstants.Players.SECOND && player_id == p2_network_id:
		p2_action_history.push_back(action)

@rpc("any_peer", "call_local")
func restart_game():
	get_tree().root.get_child(0).load_game(p1_network_id, p2_network_id)
