extends CanvasLayer

class_name Hud

@export var player0:Player
@export var player1:Player

const GAME_OVER_TEXT_TEMPLATE = \
"[center]%s
IS WORTHY[/center]"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_new_round(round_number, _moon_phase):
	$MoonPhase.frame = round_number + 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$p0Health.value = player0.health
	$p0Health/p0Charge.value = player0.charge
	$p1Health.value = player1.health
	$p1Health/p1Charge.value = player1.charge

func _on_game_over():
	_format_game_over_text()
	$AnimationPlayer.play("GameOverAnimation")

func _format_game_over_text():
	var p0_defeat = player0.health <= 0
	var p1_defeat = player1.health <= 0
	var gameOverText = $GameOverGroup/GameOverText as RichTextLabel
	var worthy_name = "MOON"
	if p1_defeat and !p0_defeat:
		worthy_name = "P1"
	elif p0_defeat and !p1_defeat:
		worthy_name = "P2"
	elif p0_defeat and p1_defeat:
		worthy_name = "NOBODY"
	else:
		$MoonPhase.frame = 0
		if player0.health > player1.health:
			worthy_name = "P1"
		elif player0.health < player1.health:
			worthy_name = "P2"
		else:
			worthy_name = "NOBODY"
	
	gameOverText.text = GAME_OVER_TEXT_TEMPLATE % worthy_name
