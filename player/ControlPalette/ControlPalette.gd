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

func _on_new_round():
	previous_action = current_action
	current_action = Actions.NONE
	if previous_action != Actions.NONE:
		action_sprites[previous_action].deactivate()
	
	var previously_disabled_actions = []
	previously_disabled_actions.append_array(disabled_actions)
	disabled_actions = determine_disabled_actions()
	
	for action in previously_disabled_actions:
		if action not in disabled_actions:
			action_sprites[action].enable()
	for action in disabled_actions:
		action_sprites[action].disable()

func determine_disabled_actions():
	var actions_to_disable = []
	if previous_action != Actions.NONE:
		actions_to_disable.append(previous_action)
	
	return actions_to_disable

func _get_all_valid_inputs(input_retrieval_method):
	var valid_inputs = []
	for input in input_mapping:
		if input_mapping[input] not in disabled_actions and input_retrieval_method.call(input):
			valid_inputs.append(input_mapping[input])
	return valid_inputs

func _update_pressed_actions_stack():
	var just_pressed_actions = _get_all_valid_inputs(Input.is_action_just_pressed)
	pressed_actions_stack.append_array(just_pressed_actions)
	
	var just_released_actions = _get_all_valid_inputs(Input.is_action_just_released)
	for action in just_released_actions:
		pressed_actions_stack.remove_at(pressed_actions_stack.find(action))
	
	return pressed_actions_stack

func _action_selected(action):
	if action != Actions.NONE and action != current_action:
		if current_action != Actions.NONE:
			action_sprites[current_action].deactivate()
		current_action = action
		action_sprites[current_action].activate()

func _process(delta):
	_update_pressed_actions_stack()
	if !pressed_actions_stack.is_empty():
		_action_selected(pressed_actions_stack.back())
