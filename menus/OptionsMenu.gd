extends Control

var config = ConfigFile.new()
var file = File.new()

func _ready():
    # sets everything to default values if config.cfg doesn't exist
    if not file.file_exists("user://config.cfg"):
        _reset_settings()
    _load_settings()
            
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
    config.load("user://config.cfg")
    config.set_value("video", "vsync", $VideoOptions/VBoxContainer/VSync.is_pressed())
    config.set_value("video", "fullscreen", $VideoOptions/VBoxContainer/Fullscreen.is_pressed())
    config.save("user://config.cfg")
        
func _load_settings():
    # loads the values from config.cfg into the ui
    config.load("user://config.cfg")
    $VideoOptions/VBoxContainer/VSync.set_pressed(config.get_value("video", "vsync"))
    $VideoOptions/VBoxContainer/Fullscreen.set_pressed(config.get_value("video", "fullscreen"))
    
func _reset_settings():
    # sets everything to default values
    config.set_value("video", "vsync", false)
    config.set_value("video", "fullscreen", false)
    config.set_value("audio", "mute", false)
    config.save("user://config.cfg")
    
func _apply_settings():
    # actually applies the settings from config.cfg in-game
    pass



