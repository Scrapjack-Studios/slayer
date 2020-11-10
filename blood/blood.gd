extends Area2D

var fall_speed = 0
var hori_speed = 1
var hori_weight = 0.001
func _physics_process(delta):
	
	if(get_overlapping_areas().empty()):
		hori_weight = 0.01
		if(fall_speed < 2):
			fall_speed += 0.01
	else:
		hori_weight = 0.1
		if(fall_speed > 0.5):
			fall_speed -= 0.1
		if(fall_speed < 0):
			fall_speed += 0.1
		
	hori_speed = lerp(hori_speed,0,hori_weight)
	position.y += fall_speed
	position.x += hori_speed
	

