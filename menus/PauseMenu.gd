extends Control

var player

func _ready():
    get_parent().get_parent().connect("game_started", self, "on_game_started")

func _process(_delta):
    if Input.is_action_just_released("pause_menu") and get_tree().paused == false:
        self.show()
        pause_game()
    elif Input.is_action_just_released("pause_menu") and get_tree().paused == true and get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/Buttons").visible == false and get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/VideoOptions").visible == false and get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/AudioOptions").visible == false:
        self.hide()
        if get_parent().get_parent().has_node(str(get_tree().get_network_unique_id())):
            get_parent().get_parent().get_node(str(get_tree().get_network_unique_id())).get_node("Chain").release()
        resume_game()
    elif Input.is_action_just_released("pause_menu") and get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/Buttons").visible == true:
        get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/Buttons").hide()
    elif Input.is_action_just_released("pause_menu") and get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/VideoOptions").visible == true:
        get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/VideoOptions").hide()
        get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/Buttons").show()
    elif Input.is_action_just_released("pause_menu") and get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/AudioOptions").visible == true:
        get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/AudioOptions").hide()
        get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/Buttons").show()

func _on_Resume_pressed():
    self.hide()
    resume_game()
    $Blip1.play()

func _on_Options_pressed():
    get_tree().get_root().get_node("GameController/CanvasLayer/OptionsMenu/Buttons").show()
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
    player = get_parent().get_parent().get_node(str(get_tree().get_network_unique_id()))

func _on_Resume_mouse_entered():
    $Hover.play()

func _on_Options_mouse_entered():
    $Hover.play()

func _on_Quit_MainMenu_mouse_entered():
    $Hover.play()

func _on_Quit_Desktop_mouse_entered():
    $Hover.play()
