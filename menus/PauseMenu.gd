extends Control

var game_controller
var options_menu
var player

func _ready():
    get_parent().get_parent().connect("game_started", self, "on_game_started")

func _process(_delta):
    if Input.is_action_just_released("pause_menu") and get_tree().paused == false:
        self.show()
        pause_game()
    elif Input.is_action_just_released("pause_menu") and get_tree().paused == true and options_menu.get_node("Buttons").visible == false and options_menu.get_node("VideoOptions").visible == false and options_menu.get_node("AudioOptions").visible == false:
        self.hide()
        resume_game()
    elif Input.is_action_just_released("pause_menu") and options_menu.get_node("Buttons").visible == true:
        options_menu.get_node("Buttons").hide()
    elif Input.is_action_just_released("pause_menu") and options_menu.get_node("VideoOptions").visible == true:
        options_menu.get_node("VideoOptions").hide()
        options_menu.get_node("Buttons").show()
    elif Input.is_action_just_released("pause_menu") and get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/AudioOptions").visible == true:
        options_menu.get_node("AudioOptons").hide()
        options_menu.get_node("Buttons").show()

func _on_Resume_pressed():
    self.hide()
    resume_game()
    $Blip1.play()

func _on_Options_pressed():
    options_menu.get_node("Buttons").show()
    $Blip1.play()

func _on_Quit_MainMenu_pressed():
    $Blip1.play()
    yield($Blip1, "finished")
    if is_network_master():
        Network.close_server()
        # warning-ignore:return_value_discarded
        get_tree().change_scene("res://MainMenu.tscn")
    else:
        # warning-ignore:return_value_discarded
        get_tree().change_scene("res://MainMenu.tscn")
    get_tree().paused = false

func _on_Quit_Desktop_pressed():
    $Blip1.play()
    yield($Blip1, "finished")
    if is_network_master():
        Network.close_server()
        get_tree().quit()
    else:
        get_tree().quit()
    
func pause_game():
    get_tree().paused = true
    # TODO: this has to be changed when multiplayer is implemented
    
func resume_game():
    get_tree().paused = false
    # TODO: this has to be changed when multiplayer is implemented
    
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
