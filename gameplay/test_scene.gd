extends Node2D

signal resolve_round_actions
signal new_round

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("resolve_round_actions", $Player1._on_resolve_round_actions)
	connect("resolve_round_actions", $Player2._on_resolve_round_actions)
	connect("new_round", $Player1/ControlPalette._on_new_round)
	connect("new_round", $Player2/ControlPalette._on_new_round)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("resolve_round_actions", [0, 1], [$Player1, $Player2], [$Player1/ControlPalette.current_action, $Player2/ControlPalette.current_action], GlobalConstants.MoonPhases.CRESCENT)
		emit_signal("new_round")
