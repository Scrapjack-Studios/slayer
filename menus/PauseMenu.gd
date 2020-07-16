extends Control

func _process(_delta):
    if Input.is_action_just_released("pause_menu") and get_tree().paused == false:
        self.show()
        pause_game()
    elif Input.is_action_just_released("pause_menu") and get_tree().paused == true and get_tree().get_root().get_node("Main/CanvasLayer/OptionsMenu/Buttons").visible == false:
        self.hide()
        get_parent().get_parent().get_node("Player").get_node("Chain").release()
        resume_game()

func _on_Resume_pressed():
    self.hide()
    resume_game()
    $Blip1.play()

func _on_Options_pressed():
    get_tree().get_root().get_node("Main/CanvasLayer/OptionsMenu/Buttons").popup()
    $Blip1.play()

func _on_Quit_MainMenu_pressed():
    $Blip1.play()
    yield($Blip1, "finished")
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://MainMenu.tscn")
    get_tree().paused = false

func _on_Quit_Desktop_pressed():
    $Blip1.play()
    yield($Blip1, "finished")
    get_tree().quit()
    
func pause_game():
    get_tree().paused = true
    # TODO: this has to be changed when multiplayer is implemented
    
func resume_game():
    get_tree().paused = false
    # TODO: this has to be changed when multiplayer is implemented

func _on_Resume_mouse_entered():
    $Hover.play()

func _on_Options_mouse_entered():
    $Hover.play()

func _on_Quit_MainMenu_mouse_entered():
    $Hover.play()

func _on_Quit_Desktop_mouse_entered():
    $Hover.play()
