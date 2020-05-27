extends Control

func _process(_delta):
    if Input.is_action_just_released("pause_menu") and get_tree().paused == false:
        $PopupMenu.popup()
        get_tree().paused = true
    elif Input.is_action_just_released("pause_menu") and get_tree().paused == true:
        $PopupMenu.hide()
        get_tree().paused = false
