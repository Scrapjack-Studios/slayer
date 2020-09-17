extends Node2D

var rng = RandomNumberGenerator.new()

func hit(pos, rot):
    $GibSound.play()
    var blood_emitter = load("res://misc/BloodSpurt.tscn").instance()
    add_child(blood_emitter)
    blood_emitter.global_position = pos
    rng.randomize()
    blood_emitter.global_rotation = rng.randf_range(-10.0, 10.0)
    blood_emitter.emitting = true
    $Timer.start(blood_emitter.lifetime)
    yield($Timer, "timeout")
    blood_emitter.queue_free()
