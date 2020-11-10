extends Node2D

const blood_draw = preload("res://blood/draw_blood.tscn")
const blood = preload("res://blood/blood.tscn")

onready var blood_draw_path = "/root/main/ViewportContainer/Viewport"
onready var blood_path = "/root/GameController"

var count = 0
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for n in range(0,10,1):
		var do_draw = blood_draw.instance()
		var do_blood = blood.instance()
	
		get_node(blood_path).add_child(do_blood)
		get_node(blood_draw_path).add_child(do_draw)
		
		do_draw.name = "blood" + String(count)
		do_blood.name = "blood" + String(count)
		
		do_blood.hori_speed = rng.randf_range(-1,1)
		do_blood.fall_speed = rng.randf_range(-1,0.5)
		
		do_draw.global_position = get_global_mouse_position()
		do_blood.global_position = get_global_mouse_position()
		count += 1
