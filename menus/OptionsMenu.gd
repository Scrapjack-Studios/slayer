extends Control

var config = ConfigFile.new()
var file = File.new()

func _ready():
    # checks if there are errors with config.cfg
    if config.load("user://config.cfg") == 7:
        # if config.cfg doesn't exist, populate it with default values
        _reset_settings()
        print("file populated with default settings")
    # if there are no file errors, continue
#    elif config.load("user://config.cfg") == 8:
#        $ErrorDialog.set_text("Bad drive")
#        $ErrorDialog.popup_centered()
#    elif config.load("user://config.cfg") == 9:
#        $ErrorDialog.set_text("Bad drive")
#        $ErrorDialog.popup_centered()
#    elif config.load("user://config.cfg") == 10:
#        $ErrorDialog.set_text("Bad drive")
#        $ErrorDialog.popup_centered()
#    elif config.load("user://config.cfg") == 11:
#        $ErrorDialog.set_text("Bad drive")
#        $ErrorDialog.popup_centered()
#    elif config.load("user://config.cfg") == 12:
#        $ErrorDialog.set_text("Bad drive")
#        $ErrorDialog.popup_centered()
#    elif config.load("user://config.cfg") == 13:
#        $ErrorDialog.set_text("Bad drive")
#        $ErrorDialog.popup_centered()
#    elif config.load("user://config.cfg") == 14:
#        $ErrorDialog.set_text("Bad drive")
#        $ErrorDialog.popup_centered()
#    elif config.load("user://config.cfg") == 15:
#        $ErrorDialog.set_text("Bad drive")
#        $ErrorDialog.popup_centered()
#    elif config.load("user://config.cfg") == 16:
#        $ErrorDialog.set_text("Bad drive")
#        $ErrorDialog.popup_centered()
#    elif config.load("user://config.cfg") == 17:
#        $ErrorDialog.set_text("Bad drive")
#        $ErrorDialog.popup_centered()
#    elif config.load("user://config.cfg") == 18:
#        $ErrorDialog.set_text("Bad drive")
#        $ErrorDialog.popup_centered()
    elif config.load("user://config.cfg") == 0:
        _load_settings()
        _apply_settings()
      
# buttons
            
func _on_Exit_pressed():
    $Buttons.hide()

func _on_Video_pressed():
    $VideoOptions.popup()

func _on_Audio_pressed():
    $Buttons.popup()
    $AudioOptions.popup()

func _on_Video_Exit_pressed():
    $Buttons.popup()
    $VideoOptions.hide()

func _on_Video_Save_pressed():
    _save_settings()
    _apply_settings()
    
func _on_Audio_Exit_pressed():
    $Buttons.popup()
    $AudioOptions.hide()

func _on_Audio_Save_pressed():
    _save_settings()
    _apply_settings()

func _on_Reset_pressed():
    $Buttons/VBoxContainer2/Reset/Reset_Confirmation.popup_centered()

func _on_Reset_Confirmation_confirmed():
    _reset_settings()
    _load_settings()
    _apply_settings()
    
func _on_VideoOptions_about_to_show():
    $Buttons.hide()

func _on_AudioOptions_about_to_show():
    $Buttons.hide()

# configuration functions

func _save_settings():
    # saves the current state of settings as specified in the ui to config.cfg
    config.load("user://config.cfg")
    # video
    config.set_value("video", "vsync", $VideoOptions/VBoxContainer/VSync.is_pressed())
    config.set_value("video", "fullscreen", $VideoOptions/VBoxContainer/Fullscreen.is_pressed())
    # audio
    config.set_value("audio", "mute", $AudioOptions/VBoxContainer/Mute.is_pressed())
    config.save("user://config.cfg")
        
func _load_settings():
    # loads the values from config.cfg into the ui
    config.load("user://config.cfg")
    # video
    $VideoOptions/VBoxContainer/VSync.set_pressed(config.get_value("video", "vsync"))
    $VideoOptions/VBoxContainer/Fullscreen.set_pressed(config.get_value("video", "fullscreen"))
    # audio
    $AudioOptions/VBoxContainer/Mute.set_pressed(config.get_value("audio", "mute"))
    
func _reset_settings():
    # sets everything to default values
    config.set_value("video", "vsync", false)
    config.set_value("video", "fullscreen", false)
    config.set_value("audio", "mute", false)
    config.save("user://config.cfg")
    
func _apply_settings():
    # actually applies the settings from config.cfg in-game
    config.load("user://config.cfg")
    OS.set_use_vsync(config.get_value("video", "vsync"))
    OS.set_window_fullscreen(config.get_value("video", "fullscreen"))
    # TODO: make this mute everything. so put all sounds in a group and mute the group
