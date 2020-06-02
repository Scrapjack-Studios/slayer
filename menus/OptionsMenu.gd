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
    elif not file.file_exists("user://config.cfg"):
        file.open("user://config.cfg", File.WRITE)
        for option_category in default_settings:
            file.store_string("[" + option_category + "]\n")
            for option in default_settings[option_category]:
                file.store_string(option + " = ")
                file.store_string(str(default_settings[option_category][option]).to_lower() + "\n")
