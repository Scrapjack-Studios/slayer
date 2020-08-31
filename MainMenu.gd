extends Control

func _on_MainMenu_tree_entered():
    if Global.kick_reason:
        $KickReason.text = "You we're kicked from the server.\nReason: " + Global.kick_reason

func _ready():
    if Global.just_launched and Global.wants_splashscreens:
        FullscreenCRT.get_node("ColorRect").show()
        $CanvasLayer/SplashScreen.show()
        $CanvasLayer/SplashScreen.play()
        Global.just_launched = false
        
func _on_SplashScreen_finished():
    $CanvasLayer/SplashScreen.hide()
    FullscreenCRT.get_node("ColorRect").hide()

func _on_PlayButton_pressed():
    $SRSetup.hide()
    $OptionsMenu.hide()
    $EditProfileMenu.hide()
    $OptionsMenu/VideoOptions.hide()
    $OptionsMenu/AudioOptions.hide()
    $PlayMenu/JoinGameMenu.hide()
    $PlayMenu/CreateGameMenu.hide()
    $PlayMenu.show()
    $PlayMenu/PlayMenuButtons.show()
    $Button2.play()
    
func _on_JoinGame_pressed():
    $Blip1.play()
    $PlayMenu/PlayMenuButtons.hide()
    $PlayMenu/JoinGameMenu.show()

func _on_Join_pressed():
    var ip = $PlayMenu/JoinGameMenu/Network/IPAddress.text
    var port = int($PlayMenu/JoinGameMenu/Network/Port.text)
    
    Global.weapon1 = $PlayMenu/JoinGameMenu/Weapons/Weapon1.get_item_text($PlayMenu/JoinGameMenu/Weapons/Weapon1.selected)
    Global.weapon2 = $PlayMenu/JoinGameMenu/Weapons/Weapon2.get_item_text($PlayMenu/JoinGameMenu/Weapons/Weapon2.selected)
    Global.weapon3 = $PlayMenu/JoinGameMenu/Weapons/Weapon3.get_item_text($PlayMenu/JoinGameMenu/Weapons/Weapon3.selected)
    Global.weapon4 = $PlayMenu/JoinGameMenu/Weapons/Weapon4.get_item_text($PlayMenu/JoinGameMenu/Weapons/Weapon4.selected)
    
    get_tree().change_scene("res://menus/LoadingScreen.tscn")
    Network.connect_to_server(ip, port, Global.username)

func _on_CreateGame_pressed():
    $Blip1.play()
    $PlayMenu/PlayMenuButtons.hide()
    $PlayMenu/CreateGameMenu.show()
    
func _on_Create_pressed():
    var port = int($PlayMenu/CreateGameMenu/Port.text)
    
    if $PlayMenu/CreateGameMenu/Map.selected == 0: # TODO: this is awful. do this some other way
        Global.map = "res://maps/ShootingRange.tscn"
    Global.weapon1 = $PlayMenu/CreateGameMenu/Weapons/Weapon1.get_item_text($PlayMenu/CreateGameMenu/Weapons/Weapon1.selected)
    Global.weapon2 = $PlayMenu/CreateGameMenu/Weapons/Weapon2.get_item_text($PlayMenu/CreateGameMenu/Weapons/Weapon2.selected)
    Global.weapon3 = $PlayMenu/CreateGameMenu/Weapons/Weapon3.get_item_text($PlayMenu/CreateGameMenu/Weapons/Weapon3.selected)
    Global.weapon4 = $PlayMenu/CreateGameMenu/Weapons/Weapon4.get_item_text($PlayMenu/CreateGameMenu/Weapons/Weapon4.selected)
    
    Network.create_server(port, Global.username)
    get_tree().change_scene("res://GameController.tscn") 

func _on_EditProfile_pressed():
    $EditProfileMenu/VBoxContainer/UserName.text = Global.username
    $Blip1.play()
    $PlayMenu.hide()
    $EditProfileMenu.show()

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
    $EditProfileMenu.hide()
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

func _on_EditProfile_mouse_entered():
    $Hover.play()
    

func _on_StartGame_pressed():
    $Blip1.play()
    
    if $SRSetup/VBoxContainer2/Map.selected == 0:
        Global.map = "res://maps/ShootingRange.tscn"
    
    Global.weapon1 = $SRSetup/VBoxContainer2/Weapon1.get_item_text($SRSetup/VBoxContainer2/Weapon1.selected)
    Global.weapon2 = $SRSetup/VBoxContainer2/Weapon2.get_item_text($SRSetup/VBoxContainer2/Weapon2.selected)
    Global.weapon3 = $SRSetup/VBoxContainer2/Weapon3.get_item_text($SRSetup/VBoxContainer2/Weapon3.selected)
    Global.weapon4 = $SRSetup/VBoxContainer2/Weapon4.get_item_text($SRSetup/VBoxContainer2/Weapon4.selected)
         
    yield($Blip1, "finished")
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://GameController.tscn")
