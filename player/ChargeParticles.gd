extends CPUParticles2D

class_name ChargeParticles
var current_charge = 0
var player:Player

func _ready():
	player = get_parent().get_parent()
	_on_charge_changed(1, "")

func _on_charge_changed(charge, _player_number):
	current_charge = charge
	if charge == 0:
		emitting = false
	else:
		amount = charge * charge
		lifetime = .5 * charge
		lifetime_randomness = 1 - .2 * charge
		spread = 25 * charge
		scale_amount_min = 3 * charge
		scale_amount_max = 8 * charge

func _process(delta):
	if current_charge != player.charge:
		_on_charge_changed(player.charge, player.player_number)
