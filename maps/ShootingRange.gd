extends Control

onready var tilemap: = $TileMap
var total_damage = 0

func hit(location_hit : Vector2, damage : float, area_effect : int):
	Explosion.new(tilemap, location_hit)
#	var pos: = location_hit
	var rand_size = 20
	var count = 6 + area_effect
	

	for i in count:
		var rand_pos: = Vector2(rand_range(-rand_size, rand_size), rand_range(-rand_size, rand_size))
		Explosion.new(tilemap, location_hit + rand_pos) 
