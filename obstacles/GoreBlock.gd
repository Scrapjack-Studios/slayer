extends Node2D

onready var rng = RandomNumberGenerator.new()

func hit(pos, rot):
    var number = rng.randi_range(1,3)
    if number == 1:
        $BloodSound1.play()
    elif number == 2:
        $BloodSound2.play()
    elif number == 3:
        $BloodSound3.play()
    
    var blood_emitter = load("res://misc/BloodSpurt.tscn").instance()
    add_child(blood_emitter)
    blood_emitter.global_position = pos
    blood_emitter.global_rotation = rng.randf_range((rot + PI) - 1, rot + PI)
    blood_emitter.emitting = true
    $Timer.start(blood_emitter.lifetime)
    yield($Timer, "timeout")
    blood_emitter.queue_free()
