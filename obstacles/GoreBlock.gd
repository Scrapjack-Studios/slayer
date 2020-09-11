extends Node2D

func hit():
    $GibSound.play()
    $BloodParticles.emitting = true
