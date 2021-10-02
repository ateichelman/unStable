extends Node

# Horse signals
# ----------------------------------------------------------------------------
# Emitted by HorseKick any time a kick goes off successfully.
signal horse_kicked
# Emitted by SpeedController whenever the speed level changes
signal horse_speed_changed(newSpeed)
# Emitted by TankTurning whenever player presses or releases a turn key
# TODO: Test to make sure this isn't firing when player is pressing both dirs.
signal horse_turning_update(state)
# Emitted by Horse whenever we start or stop drifting
signal horse_drifting_update(state)
