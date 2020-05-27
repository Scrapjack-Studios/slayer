extends Control

func _process(_delta):
    if Input.is_action_just_released("pause_menu") and get_tree().paused == false:
        $PopupMenu.popup()
        get_tree().paused = true

func _on_Resume_pressed():
    $PopupMenu.hide()
    get_tree().paused = false
