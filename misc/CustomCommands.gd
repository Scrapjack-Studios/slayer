extends Node

var spawnable_objects = {
	"blood_spurt":"misc/BloodSpurt",
	"explosion":"misc/Explosion",
	"damaging_block":"obstacles/DamagingBlock",
	"destructible_block":"obstaclesDestructibleBlock",
	"gore_block":"obstacles/GoreBlock",
	"physics_platform":"obstacles/Platform_Physics",
	"static_platform":"obstacles/Platform_Static",
}

func _ready() -> void:
	Console.add_command("kill", self, "Kill")\
		.set_description("Kills the player instantly by dealing 100 points of damage. Takes in a player username as an argument. If no username is given, kills the player that ran the command.")\
		.add_argument('victim', TYPE_STRING)\
		.register()
	Console.add_command("spawn", self, "Spawn")\
		.set_description("Spawns the specified object 500 units to the right of the player.")\
		.add_argument('object', TYPE_STRING)\
		.register()

# Custom console commands:

func Kill(victim=null):
	if get_node("/root").has_node("GameController"):
		if not victim:
			$"/root/GameController".get_node(str(get_tree().get_network_unique_id())).take_damage(100, "shotgun", Global.username)
		else:
			$"/root/GameController".get_node(str(victim)).take_damage(100, "shotgun", Global.username) # TODO: change killing weapon
	else:
		Console.write_line("This command must be executed in-game.")
	
func Spawn(object=null,position=null):
	if get_node("/root").has_node("GameController"):
		if object in spawnable_objects:
			var spawned_object = load("res://" + spawnable_objects[object] + ".tscn").instance()
			get_node("/root/GameController/" + Global.map).add_child(spawned_object)
			if position:
				spawned_object.set_position(position)
			else:
				var player_pos = get_node("/root/GameController/" + str(get_tree().get_network_unique_id())).get_position()
				spawned_object.set_position(player_pos + Vector2(500,0))		
	else:
		Console.write_line("This command must be executed in-game.") # change this to error if that's a thing
