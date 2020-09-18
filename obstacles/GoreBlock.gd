extends Node2D

func hit(pos, rot):
    $GibSound.play()
    var blood_emitter = load("res://misc/BloodSpurt.tscn").instance()
    add_child(blood_emitter)
    blood_emitter.global_position = pos
    blood_emitter.global_rotation = rot + PI
    blood_emitter.emitting = true
    $Timer.start(blood_emitter.lifetime)
    yield($Timer, "timeout")
    blood_emitter.queue_free()
