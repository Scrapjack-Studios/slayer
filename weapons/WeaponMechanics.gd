extends Node


var GunStats



func _ready():
	GunStats = get_parent().get_node("Weapon").get_node("GunStats")
	
func reload():
		var RTimer = Timer.new()
		GunStats.get_node("Sounds").get_node("ReloadSound").play()
		RTimer.set_wait_time(GunStats.ReloadTime)
		RTimer.set_one_shot(true)
		self.add_child(RTimer)
		RTimer.start()
		yield(RTimer, "timeout")
		RTimer.queue_free()
		
		GunStats.shots_fired = GunStats.mag
		GunStats.can_fire = true
	
		
		
func semi_auto():
	GunStats.fire()
		

func shotgun():
	GunStats.fire()
		

func automatic():
	GunStats.fire()
		
		  
func burst():
	GunStats.fire()



