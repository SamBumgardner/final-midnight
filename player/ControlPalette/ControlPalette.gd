extends Node2D

class_name ControlPalette

@onready var charge_sprite = $Charge as ControlPaletteAction
@onready var attack_sprite = $Attack as ControlPaletteAction
@onready var daze_sprite = $Daze as ControlPaletteAction
@onready var block_sprite = $Block as ControlPaletteAction
@onready var action_sprites = [charge_sprite, attack_sprite, daze_sprite, block_sprite]

enum Actions {CHARGE, ATTACK, DAZE, BLOCK, NONE}
@export var input_mapping = {
		"ui_up": Actions.CHARGE, 
		"ui_right": Actions.ATTACK, 
		"ui_down": Actions.DAZE,
		"ui_left": Actions.BLOCK
	}

var previous_action = Actions.NONE
var current_action = Actions.NONE
var pressed_actions_stack = []
var disabled_actions = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_action_complete():
	previous_action = current_action
	current_action = Actions.NONE

func _get_first_valid_input(input_retrieval_method):
	for input in input_mapping:
		if input_mapping[input] not in disabled_actions and input_retrieval_method.call(input):
			return input_mapping[input]
	return Actions.NONE

func _check_action_changed():
	var pressed_action = Actions.NONE 
	pressed_action = _get_first_valid_input(Input.is_action_just_pressed)
	
	if pressed_action == Actions.NONE:
		if _get_first_valid_input(Input.is_action_just_released) != Actions.NONE:
			pressed_action = _get_first_valid_input(Input.is_action_pressed)
	
	return pressed_action

func _action_selected(action):
	if action != Actions.NONE and action != current_action:
		if current_action != Actions.NONE:
			action_sprites[current_action].deactivate()
		current_action = action
		action_sprites[current_action].activate()

func _process(delta):
	var new_action = _check_action_changed()
	_action_selected(new_action)
