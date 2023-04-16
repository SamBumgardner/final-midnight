extends Node2D

class_name ControlPalette


signal action_activated #Action to activate
signal actions_disabled #list of disabled Action

@export var player_identifier = "p0"
@export var input_mapping = {
		"%s_up": GlobalConstants.Actions.CHARGE, 
		"%s_forward": GlobalConstants.Actions.ATTACK, 
		"%s_down": GlobalConstants.Actions.DAZE,
		"%s_back": GlobalConstants.Actions.BLOCK
	}

var previous_action = GlobalConstants.Actions.NONE
var current_action = GlobalConstants.Actions.NONE
var pressed_actions_stack = []
var disabled_actions = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		connect("action_activated", child._on_action_activated)
		connect("actions_disabled", child._on_actions_disabled)

func _on_new_round():
	previous_action = current_action
	current_action = GlobalConstants.Actions.NONE
	emit_signal("action_activated", current_action)
	
	disabled_actions = determine_disabled_actions()
	emit_signal("actions_disabled", disabled_actions)
	
	pressed_actions_stack.clear()

func determine_disabled_actions():
	var actions_to_disable = []
	if previous_action != GlobalConstants.Actions.NONE:
		actions_to_disable.append(previous_action)
	
	return actions_to_disable

func _get_all_valid_inputs(input_retrieval_method):
	var valid_inputs = []
	for input in input_mapping:
		if input_mapping[input] not in disabled_actions and input_retrieval_method.call(input % player_identifier):
			valid_inputs.append(input_mapping[input])
	return valid_inputs

func _update_pressed_actions_stack():
	var just_pressed_actions = _get_all_valid_inputs(Input.is_action_just_pressed)
	pressed_actions_stack.append_array(just_pressed_actions)
	
	var just_released_actions = _get_all_valid_inputs(Input.is_action_just_released)
	for action in just_released_actions:
		var released_action_index = pressed_actions_stack.find(action)
		if released_action_index >= 0:
			pressed_actions_stack.remove_at(released_action_index)

	return pressed_actions_stack

func _action_selected(action):
	if action != GlobalConstants.Actions.NONE \
			and action != current_action \
			and action not in disabled_actions:
		current_action = action
		emit_signal("action_activated", current_action)

func _process(delta):
	_update_pressed_actions_stack()
	if !pressed_actions_stack.is_empty():
		_action_selected(pressed_actions_stack.back())
