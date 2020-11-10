extends Area2D

#This goes in the viewport to be draw, it's invisible unless, the
#blood that's in main game touches an area2d, then we show, which will paint
# it will paint due to this viewport not updating it's clear.

func _physics_process(delta):
	
	var blood = get_node("/root/GameController" + self.name)
	if(blood != null):
		if(blood.get_overlapping_areas().empty()):
			visible = false
		else:
			visible = true
		
		global_position = blood.global_position
	if(position.y > 400):
		blood.queue_free()
		queue_free()
		
		
