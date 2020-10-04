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

var console_history_saved = false

func _ready() -> void:
    Console.get_node("Console").connect("console_history_saved", self, "on_console_history_saved")

func quit():
    emit_signal("quitting")
    
func _process(_delta: float) -> void:
    # make sure everyone is good with quitting
    if console_history_saved:
        get_tree().quit()
    
func on_console_history_saved():
    console_history_saved = true
    # This back and forth unfortunately causes a 1 second delay and quitting. Maybe I can fix that.
    
