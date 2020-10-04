extends Node

signal quitting

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

func _ready() -> void:
    Console.get_node("Console").connect("quit_ready", self, "on_quit_ready")

func quit():
    emit_signal("quitting")
    
func on_quit_ready():
    get_tree().quit()
    # This back and forth unfortunately causes a 1 second delay and quitting. Maybe I can fix that.
    
