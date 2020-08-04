extends Control

var config = ConfigFile.new()
var username

func _ready():
    if config.load("user://profile.cfg") == 7:
        config.set_value("profile", "username", "Player")
        config.save("user://profile.cfg")
    elif config.load("user://profile.cfg") == 0 and not config.get_value("profile", "username") == "Player":
        $VBoxContainer/UserName.set_text(config.get_value("profile", "username"))
        
    Global.username = config.get_value("profile", "username")

func _on_UserName_text_changed(new_text):
    username = new_text

func _on_Save_pressed():
    if $VBoxContainer/UserName.text:
        config.set_value("profile", "username", username)
        config.save("user://profile.cfg")
    else:
        config.set_value("profile", "username", "Player")
        config.save("user://profile.cfg")
