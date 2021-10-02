extends KinematicBody2D

export (float) var accelRate = 150.0
export (float) var deccelRate = 100.0
export (int) var speedPerTier = 100
export (float) var baseTurnRate = 1.5
export (float) var turnRateMod = 0.75

var _driftFlag = false
var _turningFlag = false
var _speedSetting = 0
var _curMaxSpeed = 0
var _curSpeed = 0.0
var _rotationDirection = 0

onready var travelDirection = $TravelDirection

# Horse
# ---------------------------
# Responsible for movement, knowing its accelleration rates and responding to
# changes made in direction, heading, and max speed by its children.
# TODO: Drifting happens when we are brake decelerating while speed is over
# some threshold

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("horse_turning_update",self,"update_turning_flag")
	Events.connect("horse_speed_changed",self,"_on_speed_shift")

func _process(delta):
	if _curSpeed > _curMaxSpeed:
		if !_driftFlag:
			_toggle_drift()
		# Deccelerate
		_curSpeed = clamp((_curSpeed - (deccelRate * delta)),_curMaxSpeed, 20000.0)
	if _curSpeed <= _curMaxSpeed:
		if _driftFlag:
			_toggle_drift()
		# Accelerate
		_curSpeed = clamp((_curSpeed + (accelRate * delta)),0.0, _curMaxSpeed)
	# update rotation if drifting
	var rotationMod = baseTurnRate * (pow(turnRateMod, floor(_curSpeed/speedPerTier) + 1)) * delta * _rotationDirection
	
	if _driftFlag && _turningFlag:
		# We're turning while drifting, have horse sprite direction and the travel direction split.
		var driftTurnMod = (baseTurnRate * delta * _rotationDirection) - rotationMod
		global_rotation = wrapf(global_rotation + driftTurnMod, -179.9, 179.9)
		travelDirection.global_rotation = wrapf(travelDirection.global_rotation - driftTurnMod, -179.9, 179.9)
	
	if _driftFlag:
		# Have travelDirection steadily return to horse direction on its own.
		travelDirection.global_rotation = lerp_angle( travelDirection.global_rotation, global_rotation, ((pow(turnRateMod, floor(_curSpeed/speedPerTier) + 1)) * delta))
	
	global_rotation = wrapf(global_rotation + rotationMod, 0-179.9, 179.9)
	var velocity = get_travel_vec().normalized() * (_curSpeed * delta)
	move_and_collide(velocity)

#func _do_drift_calculations(delta):
#	# how fast we'll be turning
#	var speedModRotation = baseTurnRate * (pow(turnRateMod, floor(_curSpeed/speedPerTier) + 1)) * delta
#	# determine turn direction
#	if (travelDirection.transform.get_rotation() - transform.get_rotation()) > (transform.get_rotation() - travelDirection.transform.get_rotation()):
#		speedModRotation *= -1
#	turn_travel_dir(-speedModRotation)

func _toggle_drift():
	_driftFlag = !_driftFlag
	if !_driftFlag:
		# TODO: Fix any drift rotation by getting image rotation
		travelDirection.global_rotation = global_rotation
	Events.emit_signal("horse_drifting_update",_driftFlag)

func _on_speed_shift(dir):
	_speedDir = dir

func get_travel_vec():
	var dir = travelDirection.global_rotation
	return Vector2(cos(dir), sin(dir))

func turn_travel_dir(newVal):
	travelDirection.global_rotation += newVal

func turn_horse(newVal):
	_rotationDirection = newVal

func update_turning_flag(state):
	_turningFlag = state
