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
	Console.add_command("kill", self, "Kill")\
		.set_description("Kills the player instantly by dealing 100 points of damage. Takes in a player username as an argument. If no username is given, kills the player that ran the command.")\
		.add_argument('victim', TYPE_STRING)\
		.register()
	Console.add_command("spawn", self, "Spawn")\
		.set_description("Spawns the specified object at the specified position. If no position is specified, the object is spawned 10 units to the right of the player.")\
		.add_argument('object', TYPE_STRING)\
		.add_argument('position', TYPE_VECTOR2)\
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
	
func Spawn(object=null,position=Vector2(10,0)):
	print(object)
