extends Control

onready var scrollback_position = 0

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_console"):
        if not visible:
            show()
        elif visible:
            hide()
    if event.is_action_pressed("ui_accept"):
        update_scrollback($Scrollback/Prompt/LineEdit.text)
        run_command($Scrollback/Prompt/LineEdit.text)
        $Scrollback/Prompt/LineEdit.clear()
        
func update_scrollback(command):
    var scrollback_line = load("res://menus/console/ScrollbackLine.tscn").instance()
    scrollback_line.text = "$ " + command
    $Scrollback.add_child(scrollback_line)
    $Scrollback.move_child(scrollback_line, scrollback_position)
    scrollback_position += 1
    
func console_print(statement):
    var scrollback_line = load("res://menus/console/ScrollbackLine.tscn").instance()
    scrollback_line.text = str(statement)
    $Scrollback.add_child(scrollback_line)
    $Scrollback.move_child(scrollback_line, scrollback_position)
    scrollback_position += 1
        
func run_command(command):
    if command == "help":
        Help()
        
func Help():
    console_print("Figure it out yourself")

