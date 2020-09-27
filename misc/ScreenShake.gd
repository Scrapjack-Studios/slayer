extends Node2D

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0

onready var camera = get_parent()

func new_shake():
    var rand = Vector2()
    rand.x = rand_range(-amplitude, amplitude)
    rand.x = rand_range(-amplitude, amplitude)
    
    $ShakeTween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, TRANS, EASE)
    $ShakeTween.start()
