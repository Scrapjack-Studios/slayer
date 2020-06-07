extends Control

func _ready():
    pass


func _on_PlayButton_pressed():
    $PlayMenu.popup()


func _on_ShootingRange_pressed():
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://maps/ShootingRange.tscn")
