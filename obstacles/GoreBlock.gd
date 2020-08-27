extends Node2D



    
func hit():
    $AudioStreamPlayer.play(0.24)
    $RigidBodyParticles2D.set_emitting(true)
    var RTimer = Timer.new()
    RTimer.set_wait_time(1)
    RTimer.set_one_shot(true)
    self.add_child(RTimer)
    RTimer.start()
    yield(RTimer, "timeout")
    RTimer.queue_free()
    $RigidBodyParticles2D.set_emitting(false)
