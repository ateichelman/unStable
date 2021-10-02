extends Node

export (float) var kickRate = 2.0 # once every 2 seconds, I guess?

var _kickCooldown = 0.0
var _is_turning = false
var _is_drifting = false

# HorseKick
# -------------------------
# Lets horse do a little kick!
# Tells parent via signal that player has issued a kick command.
# keeps track of things like cooldown and whatnot.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if (_kickCooldown > 0.0):
		_kickCooldown = clamp((_kickCooldown - delta),0.0,kickRate)

func _unhandled_input(event):
	if event.is_action_released("input_space"):
		if _kickCooldown == 0 && !_is_drifting:
			Events.emit_signal("horse_kicked")
	pass

# TODO: Connect to a global signal.
func _on_turning_toggle(state):
	_is_turning = state

# TODO Connect to global signal
func _on_drifting_toggle(state):
	_is_drifting = state
