extends Control

func _ready():
    pass
            
func _on_Exit_pressed():
    $Buttons.hide()

func _on_Video_pressed():
    $VideoOptions.popup()

func _on_Audio_pressed():
    $AudioOptions.popup()

func _on_Video_Exit_pressed():
    $VideoOptions.hide()

func _on_Video_Save_pressed():
    _save_settings()
    
func _on_Audio_Exit_pressed():
    $AudioOptions.hide()



func _save_settings():
    # saves the current state of settings as specified in the ui to config.cfg
    var config = ConfigFile.new()
    var file = File.new()
    if file.file_exists("user://config.cfg"):
        config.load("user://config.cfg")
        config.set_value("video", "vsync", $VideoOptions/VBoxContainer/VSync.is_pressed())
        config.save("user://config.cfg")
    elif not file.file_exists("user://config.cfg"):
        # sets everything to default values if config.cfg doesn't exist
        config.set_value("video", "vsync", false)
        config.set_value("video", "fullscreen", false)
        config.set_value("audio", "mute", false)
        config.save("user://config.cfg")
        
func _load_settings():
    # loads the values from config.cfg into the ui
    pass
    
func _reset_settings():
    # resets the values in the ui
    # when _save_settings() is called, they also get reset in config.cfg
    pass
    
func _apply_settings():
    # actually enables the settings from config.cfg in-game
    pass



