extends Control

onready var scrollback_position = 0

var admin = true

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_console"):
        if visible:
            visible = false
        elif not visible:
            visible = true
            $Scrollback/Prompt/LineEdit.call_deferred("grab_focus")
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
        
func run_command(command, argument=""):
    if command == "help":
        Help()
    if command == "kill":
        if $"/root".has_node("GameController"):
            if not argument:
                var victim = $"/root/GameController".get_node(str(get_tree().get_network_unique_id()))
                victim.take_damage(100)
        else:
            console_print("You must be in a game to run this command")
        
        
func Help():
    console_print("Figure it out yourself")
    
func KillSelf():
    
    $"/root"
    

