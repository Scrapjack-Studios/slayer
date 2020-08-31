extends Control

var config = ConfigFile.new()
var string_splitter
var selected_id

func _ready():
    # checks if there are errors with config.cfg
    if config.load("user://config.cfg") == 7:
        # if config.cfg doesn't exist, populate it with default values
        _reset_settings()
    elif config.load("user://config.cfg") == 0:
        _load_settings()
        _apply_settings()

# configuration functions

func _save_settings():
    # saves the current state of settings as specified in the ui to config.cfg
    config.load("user://config.cfg")
    # video
    config.set_value("video", "vsync", $VideoOptions/VBoxContainer/VSync.is_pressed())
    config.set_value("video", "fullscreen", $VideoOptions/VBoxContainer/Fullscreen.is_pressed())
    config.set_value("video", "fullscreen_crt", $VideoOptions/VBoxContainer/FullscreenCRT.is_pressed())
    config.set_value("video", "fps_counter", $VideoOptions/VBoxContainer/FPSCounter.is_pressed())
    config.set_value("video", "splash_screens", $VideoOptions/VBoxContainer/SplashScreens.is_pressed())
    
    selected_id = get_node("VideoOptions/VBoxContainer/Resolution").get_selected_id()
    string_splitter = get_node("VideoOptions/VBoxContainer/Resolution").get_item_text(selected_id).split("x")
    config.set_value("video", "vid_width", int(string_splitter[0]))
    config.set_value("video", "vid_height", int(string_splitter[1]))
    
    # audio
    config.set_value("audio", "mute", $AudioOptions/VBoxContainer/Mute.is_pressed())
    config.set_value("audio", "music_volume", $AudioOptions/VBoxContainer/MusicVolume.value)
    config.set_value("audio", "game_volume", $AudioOptions/VBoxContainer/GameVolume.value)
    config.set_value("audio", "menu_volume", $AudioOptions/VBoxContainer/MenuVolume.value)
    
    config.save("user://config.cfg")
        
func _load_settings():
    # loads the values from config.cfg into the ui
    config.load("user://config.cfg")
    # video
    $VideoOptions/VBoxContainer/VSync.set_pressed(config.get_value("video", "vsync"))
    $VideoOptions/VBoxContainer/Fullscreen.set_pressed(config.get_value("video", "fullscreen"))
    $VideoOptions/VBoxContainer/FullscreenCRT.set_pressed(config.get_value("video", "fullscreen_crt"))
    $VideoOptions/VBoxContainer/FPSCounter.set_pressed(config.get_value("video", "fps_counter"))
    for item in get_node("VideoOptions/VBoxContainer/Resolution").get_item_count():
        string_splitter = get_node("VideoOptions/VBoxContainer/Resolution").get_item_text(item).split("x")
        if int(string_splitter[0]) == config.get_value("video", "vid_width") && int(string_splitter[1]) == config.get_value("video", "vid_height"):
            get_node("VideoOptions/VBoxContainer/Resolution").select(item)
    $VideoOptions/VBoxContainer/SplashScreens.set_pressed(config.get_value("video", "splash_screens")) 
            
    # audio
    $AudioOptions/VBoxContainer/Mute.set_pressed(config.get_value("audio", "mute"))
    $AudioOptions/VBoxContainer/MusicVolume.set_value(config.get_value("audio", "music_volume"))
    $AudioOptions/VBoxContainer/GameVolume.set_value(config.get_value("audio", "game_volume"))
    $AudioOptions/VBoxContainer/MenuVolume.set_value(config.get_value("audio", "menu_volume"))
    
func _reset_settings():
    # sets everything to default values
    config.set_value("video", "vsync", false)
    config.set_value("video", "fullscreen", false)
    config.set_value("video", "fullscreen_crt", false)
    config.set_value("video", "fps_counter", false)
    config.set_value("video", "vid_width", 1920)
    config.set_value("video", "vid_height", 1080)
    config.set_value("video", "splash_screens", true)
    config.set_value("audio", "mute", false)
    config.set_value("audio", "music_volume", 50)
    config.set_value("audio", "game_volume", 50)
    config.set_value("audio", "menu_volume", 50)
    config.save("user://config.cfg")
    
func _apply_settings():
    # actually applies the settings from config.cfg in-game
    config.load("user://config.cfg")
    
    # video
    OS.set_use_vsync(config.get_value("video", "vsync"))
    
    OS.set_window_fullscreen(config.get_value("video", "fullscreen"))
    
    get_node("/root/FullscreenCRT/ColorRect").visible = config.get_value("video", "fullscreen_crt")
    if get_node("/root").has_node("MainMenu"):
        get_node("/root/MainMenu/CanvasLayer/CRTShader").visible = not config.get_value("video", "fullscreen_crt")
    
    get_node("/root/FPSCounter/RichTextLabel").visible = config.get_value("video", "fps_counter")
    
    OS.set_window_size(Vector2(config.get_value("video", "vid_width"), config.get_value("video", "vid_height")))
    
    Global.wants_splashscreens = config.get_value("video", "splash_screens")
    
    # audio
    AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), config.get_value("audio", "mute"))
    AudioServer.set_bus_mute(AudioServer.get_bus_index("Game SFX"), config.get_value("audio", "mute"))
    AudioServer.set_bus_mute(AudioServer.get_bus_index("Menu SFX"), config.get_value("audio", "mute"))
    
    if not config.get_value("audio", "mute"):
        AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(config.get_value("audio", "music_volume")/100))
        AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Game SFX"), linear2db(config.get_value("audio", "game_volume")/100))
        AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Menu SFX"), linear2db(config.get_value("audio", "menu_volume")/100))

    _save_settings()

# buttons
            
func _on_Exit_pressed():
    $Blip1.play()
    $Buttons.hide()

func _on_Video_pressed():
    $Blip1.play()
    $Buttons.hide()
    $VideoOptions.show()

func _on_Audio_pressed():
    $Blip1.play()
    $Buttons.hide()
    $AudioOptions.show()

func _on_Video_Exit_pressed():
    $Blip1.play()
    $Buttons.show()
    $VideoOptions.hide()

func _on_Video_Save_pressed():
    $Blip1.play()
    _save_settings()
    _apply_settings()
    
func _on_Audio_Exit_pressed():
    $Blip1.play()
    $Buttons.show()
    $AudioOptions.hide()

func _on_Audio_Save_pressed():
    $Blip1.play()
    _save_settings()
    _apply_settings()

func _on_Reset_pressed():
    $Blip1.play()
    $Buttons/VBoxContainer2/Reset/Reset_Confirmation.popup_centered()

func _on_Reset_Confirmation_confirmed():
    _reset_settings()
    _load_settings()
    _apply_settings()

func _on_Video_mouse_entered():
    $Hover.play()

func _on_Audio_mouse_entered():
    $Hover.play()

func _on_Reset_mouse_entered():
    $Hover.play()

func _on_Exit_mouse_entered():
    $Hover.play()


func _on_VSync_mouse_entered():
    $Hover.play()


func _on_Fullscreen_mouse_entered():
    $Hover.play()


func _on_FullscreenCRT_mouse_entered():
    $Hover.play()


func _on_FPSCounter_mouse_entered():
    $Hover.play()


func _on_Video_Save_mouse_entered():
    $Hover.play()


func _on_Video_Exit_mouse_entered():
    $Hover.play()


func _on_Mute_mouse_entered():
    $Hover.play()


func _on_Audio_Save_mouse_entered():
    $Hover.play()


func _on_Audio_Exit_mouse_entered():
    $Hover.play()
    
func _on_Resolution_mouse_entered():
    $Hover.play()

func _on_VSync_pressed():
    $Blip2.play()


func _on_Fullscreen_pressed():
    $Blip2.play()


func _on_FullscreenCRT_pressed():
    $Blip2.play()


func _on_FPSCounter_pressed():
    $Blip2.play()


func _on_Mute_pressed():
    $Blip2.play()


func _on_Resolution_pressed():
    $Blip2.play()
