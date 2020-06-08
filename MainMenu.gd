extends Control

func _ready():
    pass

func _on_PlayButton_pressed():
    $PlayMenu.popup()

func _on_ShootingRange_pressed():
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://maps/ShootingRange.tscn")

func _on_OptionsButton_pressed():
    $OptionsMenu/Buttons.set_position(Vector2(105,103))
    $OptionsMenu/Buttons.set_size(Vector2(959,869))
    $OptionsMenu/Buttons.anchor_left = 0.055
    $OptionsMenu/Buttons.anchor_top = 0.102
    $OptionsMenu/Buttons.anchor_right = 0.554
    $OptionsMenu/Buttons.anchor_bottom = 0.902
    $OptionsMenu/Buttons.margin_left = 0
    $OptionsMenu/Buttons.margin_top = 0
    $OptionsMenu/Buttons.margin_right = 0
    $OptionsMenu/Buttons.margin_bottom = 0
    $OptionsMenu/Buttons/Panel.hide()
    $OptionsMenu/Buttons.popup()

func _on_QuitButton_pressed():
    get_tree().quit()
