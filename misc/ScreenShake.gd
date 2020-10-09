extends Node2D

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0

onready var camera = get_parent()

#warning-ignore:shadowed_variable
#warning-ignore:shadowed_variable
func start(duration, frequency = 15, amplitude = 16, priority = 0):
	if priority >= self.priority:
		self.priority = priority
		self.amplitude = amplitude
		
		$Duration.start(duration)
		$Frequency.start(1 / float(frequency))

func new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.x = rand_range(-amplitude, amplitude)
	
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()

func reset():
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()
	
	priority = 0

func _on_Frequency_timeout() -> void:
	new_shake()

func _on_Duration_timeout() -> void:
	reset()
	$Frequency.stop()
