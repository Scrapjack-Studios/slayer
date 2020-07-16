extends Control

func _ready():
    pass

func _on_PlayButton_pressed():
    $SRSetup.hide()
    $OptionsMenu.hide()
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
    $PlayMenu.hide()
    $SRSetup.hide()
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
    
    $OptionsMenu/VideoOptions.set_position(Vector2(105,103))
    $OptionsMenu/VideoOptions.set_size(Vector2(959,869))
    $OptionsMenu/VideoOptions.anchor_left = 0.055
    $OptionsMenu/VideoOptions.anchor_top = 0.102
    $OptionsMenu/VideoOptions.anchor_right = 0.554
    $OptionsMenu/VideoOptions.anchor_bottom = 0.902
    $OptionsMenu/VideoOptions.margin_left = 0
    $OptionsMenu/VideoOptions.margin_top = 0
    $OptionsMenu/VideoOptions.margin_right = 0
    $OptionsMenu/VideoOptions.margin_bottom = 0
    $OptionsMenu/VideoOptions.set_exclusive(false)
    $OptionsMenu/VideoOptions/Panel.hide()
    
    $OptionsMenu/AudioOptions.set_position(Vector2(105,103))
    $OptionsMenu/AudioOptions.set_size(Vector2(959,869))
    $OptionsMenu/AudioOptions.anchor_left = 0.055
    $OptionsMenu/AudioOptions.anchor_top = 0.102
    $OptionsMenu/AudioOptions.anchor_right = 0.554
    $OptionsMenu/AudioOptions.anchor_bottom = 0.902
    $OptionsMenu/AudioOptions.margin_left = 0
    $OptionsMenu/AudioOptions.margin_top = 0
    $OptionsMenu/AudioOptions.margin_right = 0
    $OptionsMenu/AudioOptions.margin_bottom = 0
    $OptionsMenu/AudioOptions.set_exclusive(false)
    $OptionsMenu/AudioOptions/Panel.hide()
    
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
    if $SRSetup/VBoxContainer2/Weapon1.selected == 0:
        $"/root/WeaponVariables".weapon1 = "shotgun"
    if $SRSetup/VBoxContainer2/Weapon1.selected == 1:
        $"/root/WeaponVariables".weapon1 = "assault_rifle"
    if $SRSetup/VBoxContainer2/Weapon1.selected == 2:
        $"/root/WeaponVariables".weapon1 = "pistol"
    if $SRSetup/VBoxContainer2/Weapon1.selected == 3:
        $"/root/WeaponVariables".weapon1 = "m1"
         
    if $SRSetup/VBoxContainer2/Weapon2.selected == 0:
        $"/root/WeaponVariables".weapon2 = "shotgun"
    if $SRSetup/VBoxContainer2/Weapon2.selected == 1:
        $"/root/WeaponVariables".weapon2 = "assault_rifle"
    if $SRSetup/VBoxContainer2/Weapon2.selected == 2:
        $"/root/WeaponVariables".weapon2 = "pistol"
    if $SRSetup/VBoxContainer2/Weapon2.selected == 3:
        $"/root/WeaponVariables".weapon1 = "m1"
        
    if $SRSetup/VBoxContainer2/Weapon3.selected == 0:
        $"/root/WeaponVariables".weapon3 = "shotgun"
    if $SRSetup/VBoxContainer2/Weapon3.selected == 1:
        $"/root/WeaponVariables".weapon3 = "assault_rifle"
    if $SRSetup/VBoxContainer2/Weapon3.selected == 2:
        $"/root/WeaponVariables".weapon3 = "pistol"
    if $SRSetup/VBoxContainer2/Weapon3.selected == 3:
        $"/root/WeaponVariables".weapon1 = "m1"
        
    if $SRSetup/VBoxContainer2/Weapon4.selected == 0:
        $"/root/WeaponVariables".weapon4 = "shotgun"
    if $SRSetup/VBoxContainer2/Weapon4.selected == 1:
        $"/root/WeaponVariables".weapon4 = "assault_rifle"
    if $SRSetup/VBoxContainer2/Weapon4.selected == 2:
        $"/root/WeaponVariables".weapon4 = "pistol"
    if $SRSetup/VBoxContainer2/Weapon4.selected == 3:
        $"/root/WeaponVariables".weapon1 = "m1"
    
    yield($Blip1, "finished")
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://maps/ShootingRange.tscn")

