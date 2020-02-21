extends KinematicBody2D

export (PackedScene) var Bullet
export (int) var speed
export (float) var turret_speed
export (String) var bullet_type
export (int) var detect_radius
export (int) var damage
export (int) var start_health
export (float) var bullet_lifetime

var green_bar = preload("res://art/ui/barGreen_horizontalMid.png")
var yellow_bar = preload("res://art/ui/barYellow_horizontalMid.png")
var red_bar = preload("res://art/ui/barRed_horizontalMid.png")
var target = null
var health
var parent
var alive

func _ready():
	alive = true
	$HealthBar.hide()
	health = start_health
	$Detect/CollisionShape2D.shape.radius = detect_radius
	parent = get_parent()

func shoot():
	$GunTimer.start()
	$AnimationPlayer.play("MuzzleFlash")
	#yield($AnimationPlayer, "animation_finished")
	var b = Bullet.instance()
	b.start_at($"Turret/Muzzle".global_position, $Turret.global_rotation,
				bullet_type, damage, bullet_lifetime)
	$Bullets.add_child(b)
	
func _process(delta):
	if not alive:
		return
	if parent is PathFollow2D:
		parent.set_offset(parent.get_offset() + speed * delta)
	else:
		# other movement code
		pass
	$HealthBar.global_rotation = 0
	var bodies = $Detect.get_overlapping_bodies()
	if target in bodies:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Turret.global_rotation)
		var steer = (target_dir - current_dir) * turret_speed * delta
		$Turret.global_rotation = (current_dir + steer).angle()
		if target_dir.dot(current_dir) > 0.75 and $GunTimer.get_time_left() == 0:
			shoot()

func take_damage(amount):
	$HealthBar.show()
	health -= amount
	update_healthbar()
	if health <= 0:
		alive = false
		$Sprite.hide()
		$Turret.hide()
		$Explosion.show()
		$Explosion.play("boom")
		
func update_healthbar():
	var pct = (health * 100 / start_health)
	$HealthBar/Bar.value = pct
	var bar_texture = green_bar
	if pct < 40:
		bar_texture = red_bar
	elif pct < 70:
		bar_texture = yellow_bar
	$HealthBar/Bar.texture_progress = bar_texture
		
func _on_Explosion_animation_finished():
	queue_free()
