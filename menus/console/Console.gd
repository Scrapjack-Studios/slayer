extends Control

onready var scrollback_position = 0

var history = []
var histpos = 0
var admin = true

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_console"):
        if visible:
            visible = false
        elif not visible:
            visible = true
            # uses call deferred so the console hotkey isn't inputted into the line edit
            $Scrollback/Prompt/LineEdit.call_deferred("grab_focus")
    if visible:
        if event.is_action_pressed("ui_accept"):
            var user_input = $Scrollback/Prompt/LineEdit.text.split(" ")
            update_scrollback($Scrollback/Prompt/LineEdit.text)
            if len(user_input) > 1:
                run_command(user_input[0],user_input[1])
            else:
                run_command(user_input[0])
            history.append($Scrollback/Prompt/LineEdit.text)
            console_print(history)
            $Scrollback/Prompt/LineEdit.clear()
        if event.is_action_pressed("ui_up"):
            if history and histpos < len(history):
                var histinv = history.duplicate()
                histinv.invert()
                console_print(histinv[histpos])
                histpos += 1
        
# console helpers:
        
func run_command(command, argument=""):
    if command == "help":
        Help(argument)
    if command == "kill":
        if $"/root".has_node("GameController"):
            if argument:
                var username = argument
                for id in Network.players:
                    if Network.players[id]["name"] == username:
                        Kill(id)
            else:
                Kill(get_tree().get_network_unique_id())
        else:
            console_print("You must be in a game to run this command")
        
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
        
# console commands:

func Help(argument=""):
    if not argument:
        console_print("Figure it out yourself")
    elif argument == "kill":
        console_print("Kills the player instantly by dealing 100 points of damage")
        console_print("Takes in a player username as an argument. If no username is given,")
        console_print("kills the player that ran the command.")
    
func Kill(victim):
     # TODO: change weapon
    $"/root/GameController".get_node(str(victim)).take_damage(100, "shotgun", Global.username)
