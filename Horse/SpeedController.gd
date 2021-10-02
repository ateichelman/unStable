extends Node

# SpeedController
# ---------------------------
# Handle inputs that change speed, cooldown for changing.
# emits new speed level 
# TODO: up tells parent to accellerate
# neutral tells parent to decellerate at decay rate
# down tells parent to decellerate at brake rate

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var speedChange = 0
	if Input.is_action_pressed("input_up"):
		speedChange += 1
	if Input.is_action_pressed("input_down"):
		speedChange -= 1
	_on_speed_change(speedChange)
		

# TODO emit global speed change signal
func _on_speed_change(dir):
	Events.emit_signal("horse_speed_changed",dir)

