extends Sprite2D

class_name ControlPaletteAction

const TWEEN_DURATION_MAX = 1

@export var action_type = GlobalConstants.Actions.CHARGE

var tween_all = []
var tween_deactivate
var tween_activate
var tween_disable
var tween_enable

# Called when the node enters the scene tree for the first time.
func _ready():
	frame = action_type
	tween_all.append(_init_tween_deactivate())
	tween_all.append(_init_tween_activate())
	tween_all.append(_init_tween_disable())
	tween_all.append(_init_tween_enable())

func _init_tween_disable():
	tween_disable = create_tween()
	tween_disable.parallel().tween_property(self, "self_modulate", Color(Color.GRAY, .5), TWEEN_DURATION_MAX) \
		.set_trans(Tween.TRANS_CUBIC);
	tween_disable.stop()
	tween_disable.connect("finished", tween_disable.stop)
	return tween_disable

func _init_tween_enable():
	tween_enable = create_tween()
	tween_enable.parallel().tween_property(self, "self_modulate", Color.WHITE, TWEEN_DURATION_MAX)
	tween_enable.stop()
	tween_enable.connect("finished", tween_enable.stop)
	return tween_enable

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
	tween_activate.parallel().tween_property(self, "modulate", Color.PALE_GOLDENROD, .5)
	tween_activate.stop()
	tween_activate.connect("finished", tween_activate.stop)
	return tween_activate

func _on_action_activated(activated_action):
	if action_type == activated_action:
		_activate()
	else:
		_deactivate()

func _deactivate():
	tween_activate.stop()
	tween_deactivate.play()

func _activate():
	tween_deactivate.stop()
	tween_activate.play()

func _on_actions_disabled(actions_disabled):
	if action_type in actions_disabled:
		_disable()
	else:
		_enable()

func _disable():
	tween_enable.stop()
#	tween_activate.stop()
	tween_disable.play()
#	tween_deactivate.play()

func _enable():
	tween_disable.stop()
	tween_enable.play()
