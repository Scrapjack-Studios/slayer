extends Node2D

func hit(location):
    $GibSound.play()
    var blood_emitter = load("res://misc/BloodSpurt.tscn").instance()
    add_child(blood_emitter)
    blood_emitter.position = location
    blood_emitter.emitting = true
