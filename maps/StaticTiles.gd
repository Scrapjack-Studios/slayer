extends TileMap

func hit(hit_pos, weapon_rot):
	rpc("spew_blood", hit_pos, weapon_rot)

sync func spew_blood(pos, rot):
	var rng = RandomNumberGenerator.new()
	
	rng.randomize()

	var blood_emitter = load("res://misc/DirtSpurt.tscn").instance()
	add_child(blood_emitter)
	blood_emitter.global_position = pos
	blood_emitter.global_rotation = rng.randf_range((rot + PI) - 1, rot + PI)
	blood_emitter.emitting = true
	$DirtTimer.start(blood_emitter.lifetime)
	yield($DirtTimer, "timeout")
	blood_emitter.queue_free()
	

