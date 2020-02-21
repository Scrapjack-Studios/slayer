extends KinematicBody2D

signal health_changed
signal died

export (PackedScene) var Bullet
export (int) var speed
export (int) var rot_speed
export (int) var damage
export (int) var start_health
export (float) var bullet_lifetime

var velocity = Vector2()
var rot_dir
var can_shoot = true
var health
	
func _ready():
	health = start_health
	emit_signal("health_changed", health)
	
func _input(event):		
	if event.is_action_pressed("tank_fire") and can_shoot:
		can_shoot = false
		$AnimationPlayer.play("MuzzleFlash")
		#yield($AnimationPlayer, "animation_finished")
		$GunTimer.start()
		var b = Bullet.instance()
		b.start_at($"Turret/Muzzle".global_position, $Turret.global_rotation,
				   'blue', damage, bullet_lifetime)
		$Bullets.add_child(b)
	
func get_input():
	if Input.is_action_pressed("tank_forward"):
		velocity = Vector2(speed, 0).rotated(rotation)
	if Input.is_action_pressed("tank_back"):
		velocity = Vector2(-speed/2, 0).rotated(rotation)
	if Input.is_action_pressed("tank_right"):
		rot_dir += 1
	if Input.is_action_pressed("tank_left"):
		rot_dir -= 1
	
func _physics_process(delta):
	var mpos = get_global_mouse_position()
	$Turret.global_rotation = mpos.angle_to_point(position)
	velocity = Vector2()	
	rot_dir = 0
	get_input()
	rotation += rot_speed * rot_dir * delta
	move_and_collide(velocity * delta)

func _on_GunTimer_timeout():
	can_shoot = true
	
func take_damage(amount):
	health -= amount
	emit_signal("health_changed", (health * 100 / start_health))
	if health <= 0:
		emit_signal("died")
		print("Dead!")