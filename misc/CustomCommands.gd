extends Node

var spawnable_objects = {
	"blood_spurt":"misc/BloodSpurt.tscn",
	"explosion":"misc/Explosion.tscn",
	"damaging_block":"obstacles/DamagingBlock.tscn",
	"destructible_block":"obstaclesDestructibleBlock.tscn",
	"gore_block":"obstacles/GoreBlock.tscn",
	"physics_platform":"obstacles/Platform_Physics.tscn",
	"static_platform":"obstacles/Platform_Static.tscn",
}

func _ready() -> void:
	Console.add_command("kill", self, "kill")\
		.set_description("Kills the player instantly by dealing 100 points of damage. Takes in a player username as an argument. If no username is given, kills the player that ran the command.")\
		.add_argument('victim', TYPE_STRING)\
		.register()

#func Help(argument=""):
#    if argument == "help" or not argument:
#        console_print("Takes in a command as an argument, and gives a short description")
#        console_print("of the command.")
#    elif argument == "commands":
#        console_print("Prints a list of available commands.")
#    elif argument == "kill":
#        console_print("Kills the player instantly by dealing 100 points of damage")
#        console_print("Takes in a player username as an argument. If no username is given,")
#        console_print("kills the player that ran the command.")
	
func kill(victim=get_tree().get_network_unique_id()):
	 # TODO: change killing weapon
	$"/root/GameController".get_node(str(victim)).take_damage(100, "shotgun", Global.username)
	
func Spawn(object):
	print(object)
