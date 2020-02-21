extends Node

export (PackedScene) var Map

func _ready():
	set_camera_limits()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.target = $Tank
	
func set_camera_limits():
	var map_limits = $Map1.get_used_rect()
	var map_cellsize = $Map1.cell_size
	$Tank/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Tank/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$Tank/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$Tank/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y