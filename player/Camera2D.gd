extends Camera2D
class_name ShakeCamera2D

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 50)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
export (NodePath) var target  # Assign the node this camera will follow.

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
onready var noise = OpenSimplexNoise.new()
var noise_y = 0
const DEAD_ZONE = 160

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: # If the mouse moved...
		var _target = event.position - get_viewport().size	# Get the mouse position relative to the middle of the screen
		if _target.length() < DEAD_ZONE:	# If we're in the middle (dead zone)...
			self.position = Vector2(0,0)	# ... reset the camera to the middle (= center on player)
		else:
			# _target.normalized() is the direction in which to move
			# _target.length() - DEAD_ZONE is the distance the mouse is outside of the dead zone
			# 0.5 is an arbitrary scalar
			self.position = _target.normalized() * (_target.length() - DEAD_ZONE) * .2

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func _process(delta):
	if target:
		global_position = get_node(target).global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	# Using noise
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
	# Pure randomness
#	rotation = max_roll * amount * rand_range(-1, 1)
#	offset.x = max_offset.x * amount * rand_range(-1, 1)
#	offset.y = max_offset.y * amount * rand_range(-1, 1)
	
func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
