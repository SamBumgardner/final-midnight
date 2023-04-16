extends CPUParticles2D

class_name ChargeParticles

func _ready():
	_on_charge_changed(1, "")

func _on_charge_changed(charge, _player_number):
	amount = charge * charge
	lifetime = .5 * charge
	lifetime_randomness = 1 - .2 * charge
	spread = 25 * charge
	scale_amount_min = 3 * charge
	scale_amount_max = 8 * charge
	
