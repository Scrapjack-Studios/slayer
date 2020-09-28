extends Control

onready var scrollback_position = 0

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept"):
        var scrollback_line = load("res://menus/console/ScrollbackLine.tscn").instance()
        scrollback_line.text = $Scrollback/Prompt/LineEdit.text
        $Scrollback.add_child(scrollback_line)
        $Scrollback.move_child(scrollback_line, scrollback_position)
        scrollback_position += 1
        $Scrollback/Prompt/LineEdit.clear()
