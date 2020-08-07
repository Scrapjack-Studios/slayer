extends Control

func _ready():
    pass

func _on_PlayButton_pressed():
    $SRSetup.hide()
    $OptionsMenu.hide()
    $OptionsMenu/VideoOptions.hide()
    $OptionsMenu/AudioOptions.hide()
    $PlayMenu.show()
    $Button2.play()
    
func _on_JoinGame_pressed():
    $Blip1.play()

func _on_CreateGame_pressed():
    $Blip1.play()

func _on_ShootingRange_pressed():
    $Blip1.play()
    $PlayMenu.hide()
    $SRSetup.show()

func _on_OptionsButton_pressed():
    $OptionsMenu/Buttons.set_position(Vector2(0,0))
    $OptionsMenu/Buttons.set_size(Vector2(960,870))
    $OptionsMenu/Buttons/Panel.hide()
    $OptionsMenu/VideoOptions.set_position(Vector2(0,0))
    $OptionsMenu/VideoOptions.set_size(Vector2(960,870))
    $OptionsMenu/VideoOptions/Panel.hide()
    $OptionsMenu/AudioOptions.set_position(Vector2(0,0))
    $OptionsMenu/AudioOptions.set_size(Vector2(960,870))
    $OptionsMenu/AudioOptions/Panel.hide()
    $PlayMenu.hide()
    $SRSetup.hide()
    $OptionsMenu/VideoOptions.hide()
    $OptionsMenu/AudioOptions.hide()
    $OptionsMenu.show()
    $OptionsMenu/Buttons.show()
    $Button2.play()

func _on_QuitButton_pressed():
    $Button2.play()
    yield($Button2, "finished")
    get_tree().quit()

func _on_JoinGame_mouse_entered():
    $Hover.play()

func _on_CreateGame_mouse_entered():
    $Hover.play()

func _on_ShootingRange_mouse_entered():
    $Hover.play()


func _on_StartGame_pressed():
    $Blip1.play()
    
    if $SRSetup/VBoxContainer2/Map.selected == 0:
        $"/root/Global".map = load("res://maps/ShootingRange.tscn")
    
    Global.weapon1 = $SRSetup/VBoxContainer2/Weapon1.get_item_text($SRSetup/VBoxContainer2/Weapon1.selected)
    Global.weapon2 = $SRSetup/VBoxContainer2/Weapon2.get_item_text($SRSetup/VBoxContainer2/Weapon2.selected)
    Global.weapon3 = $SRSetup/VBoxContainer2/Weapon3.get_item_text($SRSetup/VBoxContainer2/Weapon3.selected)
    Global.weapon4 = $SRSetup/VBoxContainer2/Weapon4.get_item_text($SRSetup/VBoxContainer2/Weapon4.selected)
         
    yield($Blip1, "finished")
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://GameController.tscn")
    
    

