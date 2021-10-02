extends Node

const _speedLevelMax = 10
const _speedLevelMin = 0
const _speedShiftASec = 0.15
const _speedShiftDownASec = 0.05

# SpeedController
# ---------------------------
# Handle inputs that change speed, cooldown for changing.
# emits new speed level 
# TODO: up tells parent to accellerate
# neutral tells parent to decellerate at decay rate
# down tells parent to decellerate at brake rate

var _speedLevel = 0
var _speedShiftUpCooldown = 0.0
var _speedShiftDownCooldown = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if (_speedShiftUpCooldown > 0.0):
		_speedShiftUpCooldown = clamp((_speedShiftUpCooldown - delta),0.0,_speedShiftASec)
	if (_speedShiftDownCooldown > 0.0):
		_speedShiftDownCooldown = clamp((_speedShiftDownCooldown - delta),0.0,_speedShiftDownASec)
	var speedChange = 0
	if Input.is_action_pressed("input_up"):
		if _speedShiftUpCooldown == 0.0:
			speedChange += 1
			_speedShiftUpCooldown = _speedShiftASec
	if Input.is_action_pressed("input_down"):
		if _speedShiftDownCooldown == 0.0:
			speedChange -= 1
			_speedShiftDownCooldown = _speedShiftDownASec
	if speedChange != 0:
		_speedLevel = clamp((_speedLevel + speedChange),_speedLevelMin, _speedLevelMax)
		_on_speed_change(_speedLevel)
		

# TODO emit global speed change signal
func _on_speed_change(dir):
	Events.emit_signal("horse_speed_changed",dir)

# TODO Connect this to global stop signal.
func _on_stop():
	# Horse is forced to stop in its tracks for some reason
	_on_speed_change(0)
