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
    
    if $SRSetup/VBoxContainer2/Weapon1.selected == 0:
        $"/root/Global".weapon1 = "shotgun"
    if $SRSetup/VBoxContainer2/Weapon1.selected == 1:
        $"/root/Global".weapon1 = "assault_rifle"
    if $SRSetup/VBoxContainer2/Weapon1.selected == 2:
        $"/root/Global".weapon1 = "pistol"
    if $SRSetup/VBoxContainer2/Weapon1.selected == 3:
        $"/root/Global".weapon1 = "m1"
         
    if $SRSetup/VBoxContainer2/Weapon2.selected == 0:
        $"/root/Global".weapon2 = "shotgun"
    if $SRSetup/VBoxContainer2/Weapon2.selected == 1:
        $"/root/Global".weapon2 = "assault_rifle"
    if $SRSetup/VBoxContainer2/Weapon2.selected == 2:
        $"/root/Global".weapon2 = "pistol"
    if $SRSetup/VBoxContainer2/Weapon2.selected == 3:
        $"/root/Global".weapon2 = "m1"
        
    if $SRSetup/VBoxContainer2/Weapon3.selected == 0:
        $"/root/Global".weapon3 = "shotgun"
    if $SRSetup/VBoxContainer2/Weapon3.selected == 1:
        $"/root/Global".weapon3 = "assault_rifle"
    if $SRSetup/VBoxContainer2/Weapon3.selected == 2:
        $"/root/Global".weapon3 = "pistol"
    if $SRSetup/VBoxContainer2/Weapon3.selected == 3:
        $"/root/Global".weapon3 = "m1"
        
    if $SRSetup/VBoxContainer2/Weapon4.selected == 0:
        $"/root/Global".weapon4 = "shotgun"
    if $SRSetup/VBoxContainer2/Weapon4.selected == 1:
        $"/root/Global".weapon4 = "assault_rifle"
    if $SRSetup/VBoxContainer2/Weapon4.selected == 2:
        $"/root/Global".weapon4 = "pistol"
    if $SRSetup/VBoxContainer2/Weapon4.selected == 3:
        $"/root/Global".weapon4 = "m1"
    
    yield($Blip1, "finished")
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://maps/MapLoader.tscn")

