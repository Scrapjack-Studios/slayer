extends Control

func _ready():
    pass

func _on_Exit_pressed():
    $Buttons.hide()


func _on_Video_pressed():
    $VideoOptions.popup()

func _on_Audio_pressed():
    $AudioOptions.popup()
