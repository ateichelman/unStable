extends Node

signal direction_changed(newVal)

export (float) var baseTurnRate = 1.0

var _isDrifting = false
var _isTurning = false

# TankMovement
# ----------------------------------
# Takes movement inputs, calculates move dir and facing dir, and then emits signal for
# parent to either consume and move with or ignore.


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var turnDir = 0
	if Input.is_action_pressed("input_left"):
		turnDir -= 1
	if Input.is_action_pressed("input_right"):
		turnDir += 1
	
	if turnDir != 0:
		update_turning(true)
	else:
		update_turning(false)
	
	turn_horse(turnDir)
		
	
# TODO: Emit global is turning signal
func turn_horse(dir):
	emit_signal("direction_changed",dir)

# TODO: Connect this to a signal.
func update_drift(new_state):
	_isDrifting = new_state

func update_turning(newState):
	if _isTurning != newState:
		Events.emit_signal("horse_turning_update",newState)
		_isTurning = newState
