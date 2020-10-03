extends Control

onready var scrollback_position = 0

var admin = true

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_console"):
        if visible:
            visible = false
        elif not visible:
            visible = true
            # uses call deferred so the console hotkey isn't inputted into the line edit
            $Scrollback/Prompt/LineEdit.call_deferred("grab_focus") 
    if event.is_action_pressed("ui_accept"):
        var user_input = $Scrollback/Prompt/LineEdit.text.split(" ")
        update_scrollback($Scrollback/Prompt/LineEdit.text)
        if len(user_input) > 1:
            run_command(user_input[0],user_input[1])
        else:
            run_command(user_input[0])
            
        $Scrollback/Prompt/LineEdit.clear()
        
func run_command(command, argument=""):
    if command == "help":
        Help(argument)
    if command == "kill":
        if $"/root".has_node("GameController"):
            if not argument:
                KillSelf()
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
        
# Console commands:

func Help(argument=""):
    if not argument:
        console_print("Figure it out yourself")
    elif argument == "kill":
        console_print("Kills the player instantly by dealing 100 points of damage")
        console_print("Takes in a player username as an argument. If no username is given,")
        console_print("kills the player that ran the command.")
    
func KillSelf():
    var victim = $"/root/GameController".get_node(str(get_tree().get_network_unique_id()))
    victim.take_damage(100, "shotgun", str(get_tree().get_network_unique_id())) # TODO: change weapon
    

