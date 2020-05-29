extends Control

func _process(_delta):
    if Input.is_action_just_released("pause_menu") and get_tree().paused == false:
        $PopupMenu.popup()
        pause_game()
    elif Input.is_action_just_released("pause_menu") and get_tree().paused == true:
        $PopupMenu.hide()
        resume_game()

func _on_Resume_pressed():
    $PopupMenu.hide()
    resume_game()

func _on_Quit_Desktop_pressed():
    get_tree().quit()
    
func pause_game():
    get_tree().paused = true
    # TODO: this has to be changed when multiplayer is implemented
    
func resume_game():
    get_tree().paused = false
    # TODO: this has to be changed when multiplayer is implemented
