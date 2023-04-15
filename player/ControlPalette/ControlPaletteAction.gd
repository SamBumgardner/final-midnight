extends Sprite2D

class_name ControlPaletteAction

const TWEEN_DURATION_MAX = 1

var tween_all = []
var tween_deactivate
var tween_activate

# Called when the node enters the scene tree for the first time.
func _ready():
	tween_all.append(_init_tween_deactivate())
	tween_all.append(_init_tween_activate())

func _init_tween_disable():
	pass

func _init_tween_deactivate():
	tween_deactivate = create_tween()
	tween_deactivate.parallel().tween_property(self, "scale", Vector2.ONE, TWEEN_DURATION_MAX) \
		.set_trans(Tween.TRANS_CUBIC);
	tween_deactivate.parallel().tween_property(self, "modulate", Color.WHITE, TWEEN_DURATION_MAX)
	tween_deactivate.stop()
	tween_deactivate.connect("finished", tween_deactivate.stop)
	return tween_deactivate

func _init_tween_activate():
	tween_activate = create_tween();
	tween_activate.parallel().tween_property(self, "scale", Vector2.ONE * 1.2, .5) \
		.set_trans(Tween.TRANS_BACK);
	tween_activate.parallel().tween_property(self, "modulate", Color.YELLOW, TWEEN_DURATION_MAX)
	tween_activate.stop()
	tween_activate.connect("finished", tween_activate.stop)
	return tween_activate
	
func deactivate():
	tween_activate.stop()
	tween_deactivate.play()

func activate():
	tween_deactivate.stop()
	tween_activate.play()
	

func _process(delta):
	pass
