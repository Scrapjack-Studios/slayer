extends Control

onready var tilemap: = $TileMap
var total_damage = 0

func hit(location_hit : Vector2, damage : float, area_effect : int):
	Explosion.new(tilemap, location_hit) 
