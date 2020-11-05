extends Control

var game_controller
var options_menu
var player

func _ready():
	get_parent().get_parent().connect("game_started", self, "on_game_started")

func _process(_delta):
	print(game_controller.get_children())
	if Input.is_action_just_released("pause_menu") and not Global.paused:
		self.show()
		Global.pause_game()
	elif Input.is_action_just_released("pause_menu") and Global.paused and not options_menu.get_node("Buttons").visible and not options_menu.get_node("VideoOptions").visible and not options_menu.get_node("AudioOptions").visible:
		self.hide()
		Global.resume_game()
	elif Input.is_action_just_released("pause_menu") and options_menu.get_node("Buttons").visible:
		options_menu.get_node("Buttons").hide()
	elif Input.is_action_just_released("pause_menu") and options_menu.get_node("VideoOptions").visible:
		options_menu.get_node("VideoOptions").hide()
		options_menu.get_node("Buttons").show()
	elif Input.is_action_just_released("pause_menu") and options_menu.get_node("AudioOptions").visible:
		options_menu.get_node("AudioOptons").hide()
		options_menu.get_node("Buttons").show()

func _on_Resume_pressed():
	self.hide()
	Global.resume_game()
	$Blip1.play()

func _on_Options_pressed():
	options_menu.get_node("Buttons").show()
	$Blip1.play()

func _on_Quit_MainMenu_pressed():
	$Blip1.play()
	yield($Blip1, "finished")
	get_tree().change_scene("res://MainMenu.tscn")
	player.get_node("Camera2D").make_current() # fixes strange main menu bug, so don't remove it

func _on_Quit_Desktop_pressed():
	$Blip1.play()
	yield($Blip1, "finished")
	get_tree().quit()
	
func on_game_started():
	game_controller = get_parent().get_parent()
	options_menu = game_controller.get_node("CanvasLayer/OptionsMenu")
	player = game_controller.get_node(str(get_tree().get_network_unique_id()))

func _on_Resume_mouse_entered():
	$Hover.play()

func _on_Options_mouse_entered():
	$Hover.play()

func _on_Quit_MainMenu_mouse_entered():
	$Hover.play()

func _on_Quit_Desktop_mouse_entered():
	$Hover.play()
