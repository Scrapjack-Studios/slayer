extends Control

func _ready():
    _save_settings()
            
func _on_Exit_pressed():
    $Buttons.hide()

func _on_Video_pressed():
    $VideoOptions.popup()

func _on_Audio_pressed():
    $AudioOptions.popup()

func _on_Video_Exit_pressed():
    $VideoOptions.hide()

func _on_Audio_Exit_pressed():
    $AudioOptions.hide()



func _save_settings():
    var config = ConfigFile.new()
    var file = File.new()
    if file.file_exists("user://config.cfg"):
        config.load("user://config.cfg")
        config.set_value("video", "vsync", true)
        config.save("user://config.cfg")
    elif not file.file_exists("user://config.cfg"):
        # sets everything to default values if config.cfg doesn't exist
        config.set_value("video", "vsync", false)
        config.set_value("video", "fullscreen", false)
        config.set_value("audio", "mute", false)
        config.save("user://config.cfg")
