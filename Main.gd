extends Node

export (PackedScene) var Map

func _process(_delta):
    if Input.is_action_pressed("pause_menu"):
        $CanvasLayer/PauseMenu/PopupMenu.popup()
