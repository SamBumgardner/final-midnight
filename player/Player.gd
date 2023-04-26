extends Node2D

class_name Player

signal charge_changed

@export var player_number = GlobalConstants.Players.FIRST
@export var max_health = 5
@export var min_charge = 1
@export var max_charge = 5

@export var health = max_health
@export var charge = min_charge

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerSprite.frame = player_number
	$ControlPalette.player_identifier = "p%d" % player_number
	if player_number == GlobalConstants.Players.SECOND:
		scale.x = -1
		($PlayerSprite/ChargeParticles as CPUParticles2D).color = Color.CORNFLOWER_BLUE

func _on_resolve_round_actions(active_player_ids, players, player_actions, moon_phase):
	var my_action = player_actions[player_number]
	
	var opponent:Player
	var opponent_action = GlobalConstants.Actions.NONE
	for active_player_id in active_player_ids:
		if active_player_id != player_number:
			opponent = players[active_player_id]
			opponent_action = player_actions[active_player_id]
	
	match my_action:
		GlobalConstants.Actions.CHARGE:
			if opponent_action != GlobalConstants.Actions.DAZE:
				$PlayerSprite/AnimationPlayer.play("charge")
				_gain_charge(moon_phase)
		GlobalConstants.Actions.ATTACK:
			$PlayerSprite/AnimationPlayer.play("attack")
		GlobalConstants.Actions.DAZE:
			$PlayerSprite/AnimationPlayer.play("daze")
		GlobalConstants.Actions.BLOCK:
			$PlayerSprite/AnimationPlayer.play("block")
			
	match opponent_action:
		GlobalConstants.Actions.ATTACK:
			if my_action == GlobalConstants.Actions.BLOCK:
				_hurt(int(opponent.charge / 2))
			elif my_action == GlobalConstants.Actions.DAZE:
				_hurt(opponent.charge)
				# become dazed
			else:
				_hurt(opponent.charge)
		GlobalConstants.Actions.DAZE:
			if my_action == GlobalConstants.Actions.BLOCK \
					or my_action == GlobalConstants.Actions.CHARGE \
					or my_action == GlobalConstants.Actions.NONE:
				_lose_charge()
				_hurt(1)
				# become dazed

func _hurt(damage):
	health -= damage
	if health <= 0:
		emit_signal("charge_changed", 0, player_number)
		$PlayerSprite/AnimationPlayer.queue("defeat")
	
func _lose_charge():
	charge = min_charge
	emit_signal("charge_changed", charge, player_number)

func _gain_charge(charge_amount):
	charge = min(charge + charge_amount, max_charge)
	emit_signal("charge_changed", charge, player_number)

func get_current_action():
	return $ControlPalette.current_action
