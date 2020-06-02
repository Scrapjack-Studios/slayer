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

var default_settings = {
    "video_settings":
    {
        "vsync":false,
        "fullscreen":false
    },
    "audio_settings":
    {
        "mute":false
    }
}

func _save_settings():
    var file = File.new()
    if file.file_exists("user://config.cfg"):
        print($VideoOptions/VBoxContainer/VSync.is_pressed())
        print($VideoOptions/VBoxContainer/Fullscreen.is_pressed())
    elif not file.file_exists("user://config.cfg"):
        # sets everything to default values if config.cfg doesn't exist
        var config = ConfigFile.new()
        config.set_value("video", "vsync", false)
        config.set_value("video", "fullscreen", false)
        config.set_value("audio", "mute", false)
        config.save("user://config.cfg")
