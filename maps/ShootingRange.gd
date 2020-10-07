extends Control

onready var tilemap: = $TileMap
var total_damage = 0

func hit(location_hit : Vector2, damage : float):
#	var pos: = location_hit
	var rand_size: = 1
	var count: = 1
	total_damage += damage
	
	
	if total_damage == 10:
	
		for i in count:
			var rand_pos: = Vector2(rand_range(-rand_size, rand_size), rand_range(-rand_size, rand_size))
			Explosion.new(tilemap, location_hit + rand_pos) 
			total_damage = 0
