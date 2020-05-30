extends Control

func _process(_delta):
    if Input.is_action_just_released("pause_menu") and get_tree().paused == false:
        $PopupMenu.popup()
        pause_game()
    elif Input.is_action_just_released("pause_menu") and get_tree().paused == true and get_tree().get_root().get_node("Main/CanvasLayer/OptionsMenu/Popup").visible == false:
        $PopupMenu.hide()
        resume_game()

func _on_Resume_pressed():
    $PopupMenu.hide()
    resume_game()

func _on_Options_pressed():
    get_tree().get_root().get_node("Main/CanvasLayer/OptionsMenu/Popup").popup()

func _on_Quit_Desktop_pressed():
    get_tree().quit()
    
func pause_game():
    get_tree().paused = true
    # TODO: this has to be changed when multiplayer is implemented
    
func resume_game():
    get_tree().paused = false
    # TODO: this has to be changed when multiplayer is implemented



