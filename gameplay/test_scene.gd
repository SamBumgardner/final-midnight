extends Node2D

signal new_round

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("new_round", $ControlPalette._on_new_round)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("new_round")
