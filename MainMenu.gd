extends Control

func _ready():
    pass


func _on_PlayButton_pressed():
    $PlayMenu.popup()


func _on_ShootingRange_pressed():
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://maps/ShootingRange.tscn")

func _on_OptionsButton_pressed():
    $OptionsMenu/Buttons.set_size(Vector2(959,869))
    $OptionsMenu/Buttons.set_position(Vector2(105,103))
#    $OptionsMenu/Buttons/Panel.hide()
    $OptionsMenu/Buttons.popup()
