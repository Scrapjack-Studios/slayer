extends Control

func _process(_delta):
    if Input.is_action_just_released("pause_menu") and get_tree().paused == false:
        $PopupMenu.popup()
        pause_game()
    elif Input.is_action_just_released("pause_menu") and get_tree().paused == true and get_tree().get_root().get_node("Main/CanvasLayer/OptionsMenu/Buttons").visible == false:
        $PopupMenu.hide()
        resume_game()

func _on_Resume_pressed():
    $PopupMenu.hide()
    resume_game()

func _on_Options_pressed():
    get_tree().get_root().get_node("Main/CanvasLayer/OptionsMenu/Buttons").popup()

func _on_Quit_MainMenu_pressed():
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://MainMenu.tscn")
    get_tree().paused = false

func _on_Quit_Desktop_pressed():
    get_tree().quit()
    
func pause_game():
    get_tree().paused = true
    # TODO: this has to be changed when multiplayer is implemented
    
func resume_game():
    get_tree().paused = false
    # TODO: this has to be changed when multiplayer is implemented
