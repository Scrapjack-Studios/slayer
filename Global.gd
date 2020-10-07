extends Node

# Used for miscellaneous variables/functions that need to be accessible from everywhere.

var weapon1
var weapon2
var weapon3
var weapon4

var map

var username
var kick_reason = ""

var paused = false
var just_launched = true

var wants_splashscreens

func pause_game():
	var player = get_node("/root/GameController/" + str(get_tree().get_network_unique_id()))
	Global.paused = true
	player.can_grapple = false
	player.can_move = false
	player.can_jump = false
	player.get_node("Weapon/GunStats").can_fire = false
	player.get_node("Camera2D").clear_current()
	
func resume_game():
	var player = get_node("/root/GameController/" + str(get_tree().get_network_unique_id()))
	Global.paused = false
	player.can_grapple = true
	player.can_move = true
	player.can_jump = true
	player.get_node("Weapon/GunStats").can_fire = true
	player.get_node("Camera2D").make_current()
