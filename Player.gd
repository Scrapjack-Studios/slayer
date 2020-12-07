extends KinematicBody2D

signal health_changed(health)
signal died
signal respawn

const FLOOR_ANGLE_TOLERANCE = 70 # Angle in degrees towards either side that the player can consider "floor"
const WALK_FORCE = 1600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 400
const STOP_FORCE = 1500
const JUMP_MAX_AIRBORNE_TIME = 0.4
const CLIMB_SPEED = 800
const CLIMB_AMOUNT = 70
const MAX_JUMP_COUNT = 2
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 32.0

var max_health = 100
var username
var chain_velocity := Vector2(0,0)
var inertia
var push
var can_shoot = true
var can_move = true
var can_jump = true
var chain_pull = 55
var on_air_time = 100
var is_jumping = false
var can_doublejump = true
var is_falling = false
var grabbing
var prev_jump_pressed = false
var is_walking = false
var can_grapple = true
var is_grappling = false
var jump_count = 0
var is_wall_sliding = false
var has_pressed_jump
var jump_strength = 750
var is_climbing = false
var can_walljump = true
var stopped_fire = false
var burst_loop = 0
var shot = false
var grapple_count = 0
var cool_down_sound
var reload_sound
var mag_1
var mag_2
var mag_3
var mag_4
var preweapon 
var weaponnumb = 0
var stop = true
var wallmount = false
var move_speed = 400
var velocity = Vector2.ZERO
var player_state

onready var health = max_health

func _ready():
	get_node("Weapon/GunStats/Templates").get_node(Global.weapon1).activate()
	$Weapon/GunStats/Sounds/FireSound.activate()
	$Weapon/GunStats.set_sprite()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reload"):
			$WeaponMechanics.reload()
	
	if event.is_action_pressed("gun_fire") and can_shoot and $Weapon/GunStats.is_semi_auto:
		$Weapon/GunStats.rpc("fire", "semi_auto", $Weapon/Weapon_Sprite/Muzzle.global_position, $Weapon.global_rotation)
		GunTimer(false)
	if event.is_action_pressed("gun_fire") and can_shoot and $Weapon/GunStats.shotgun:
		$Weapon/GunStats.rpc("fire", "shotgun", $Weapon/Weapon_Sprite/Muzzle.global_position, $Weapon.global_rotation)
		GunTimer(false)
	if event.is_action_pressed("gun_fire") and can_shoot and $Weapon/GunStats.is_burst_fire:
		$Weapon/GunStats.rpc("fire", "burst_fire", $Weapon/Weapon_Sprite/Muzzle.global_position, $Weapon.global_rotation)
		GunTimer(false)
		
	if event.is_action_pressed("Graphook") and can_grapple:
			rotation = 0
			$Chain.rpc("shoot")
			is_grappling = true
			$Whip.hide()
			grapple_count += 1
			
	elif event.is_action_released("Graphook") and is_grappling:
		$Chain.rpc("release")
		$Whip.show()
		is_grappling = false
		if grapple_count == 3:
			can_grapple = false
			$GrappleTimer.start()
			get_parent().get_node("CanvasLayer/HUD/GrappleCooldown").show()
			grapple_count = 0

	if event.is_action_pressed("Weapon1") or event.is_action_pressed("Weapon2") or event.is_action_pressed("Weapon3") or event.is_action_pressed("Weapon4"):
		if preweapon == "Weapon1":
			mag_1 = $Weapon/GunStats.shots_fired
		if preweapon == "Weapon2":
			mag_2 = $Weapon/GunStats.shots_fired
		if preweapon == "Weapon3":
			mag_3 = $Weapon/GunStats.shots_fired
		if preweapon == "Weapon4":
			mag_4 = $Weapon/GunStats.shots_fired
		if not preweapon:
			mag_1 = get_node("Weapon/GunStats/Templates").get_node(Global.weapon1).mag
			mag_2 = get_node("Weapon/GunStats/Templates").get_node(Global.weapon2).mag
			mag_3 = get_node("Weapon/GunStats/Templates").get_node(Global.weapon3).mag
			mag_4 = get_node("Weapon/GunStats/Templates").get_node(Global.weapon4).mag

	if event.is_action_pressed("Weapon1") or weaponnumb == 1:
		get_node("Weapon/GunStats/Templates").get_node(Global.weapon1).activate()
		$Weapon/GunStats/Sounds/FireSound.activate()
		$Weapon/GunStats.set_sprite()
		preweapon = "Weapon1"
		$Weapon/GunStats.shots_fired = mag_1 
		
	if event.is_action_pressed("Weapon2") or weaponnumb == 2:
		get_node("Weapon/GunStats/Templates").get_node(Global.weapon2).activate()
		$Weapon/GunStats/Sounds/FireSound.activate()
		$Weapon/GunStats.set_sprite() 
		preweapon = "Weapon2"  
		$Weapon/GunStats.shots_fired = mag_2
		
	if event.is_action_pressed("Weapon3") or weaponnumb == 3:
		get_node("Weapon/GunStats/Templates").get_node(Global.weapon3).activate()
		$Weapon/GunStats/Sounds/FireSound.activate()
		$Weapon/GunStats.set_sprite() 
		preweapon = "Weapon3"      
		$Weapon/GunStats.shots_fired = mag_3
		
	if event.is_action_pressed("Weapon4") or weaponnumb == 4:
		get_node("Weapon/GunStats/Templates").get_node(Global.weapon4).activate()
		$Weapon/GunStats/Sounds/FireSound.activate()
		$Weapon/GunStats.set_sprite() 
		preweapon = "Weapon4"
		$Weapon/GunStats.shots_fired = mag_4

	if event.is_action_pressed("LastWeapon"):
		weaponscroll(1)

	elif event.is_action_pressed("NextWeapon"):
		weaponscroll(-1)

func weaponscroll(dir):
	weaponnumb += 1 * dir # call the zoom function 

func _physics_process(delta):
	move(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), delta)
	
	$Weapon.global_rotation = get_global_mouse_position().angle_to_point(position)
	on_air_time += delta
		
	if Input.is_action_just_pressed("hold"):
		chain_pull = 40
		
	if Input.is_action_just_released("hold"):
		chain_pull = 55

	if Input.is_action_just_pressed("jump") and can_jump:
		jump()

	if Input.is_action_pressed("gun_fire") and can_shoot and $Weapon/GunStats.is_automatic:
		$Weapon/GunStats.rpc("fire", "automatic", $Weapon/Weapon_Sprite/Muzzle.global_position, $Weapon.global_rotation)
		GunTimer(true)

	if get_local_mouse_position().x < 0: # mouse is facing left
		$Weapon.set_position(Vector2(-22,-7))
		$Weapon/Weapon_Sprite.set_flip_v(true)
		$Weapon/Weapon_Sprite/Muzzle.set_position(Vector2(6,1))
	elif get_local_mouse_position().x > 0: # mouse is facing right
		$Weapon.set_position(Vector2(15,0))
		$Weapon/Weapon_Sprite.set_flip_v(false)
		$Weapon/Weapon_Sprite/Muzzle.set_position(Vector2(6,5))

	if $Chain.hooked:
		_ChainHook()
	else:
		# Not hooked -> no chain velocity
		chain_velocity = Vector2(0,0)
	velocity += chain_velocity

	if is_on_floor() and not Global.paused:
#        rotation = get_floor_normal().angle() + PI/2
		can_jump = true
		jump_count = 0
		grapple_count = 0

	if is_on_wall() and not is_climbing:
		wall_cling()
	else:
		can_walljump = true
		wallmount = false

func move(direction, delta):
	velocity.x = direction * move_speed
	velocity.y += delta * Global.gravity
	move_and_slide_with_snap(velocity, Vector2(0,5), Vector2.UP, 1, 4, 0.9, false)
	
	for slide in get_slide_count():
		var collision = get_slide_collision(slide)
		if collision.collider.is_in_group("bodies"):
				collision.collider.apply_central_impulse(-collision.normal * 100)

func jump():
	jump_count += 1
	velocity.y = -jump_strength
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and not prev_jump_pressed and not is_jumping:
		velocity.y = -jump_strength
		is_jumping = true
	
	if jump_count >= MAX_JUMP_COUNT:
		can_jump = false 
	prev_jump_pressed = Input.is_action_pressed("jump")
	# Jump must also be allowed to happen if the character left the floor a little bit ago. Makes controls more snappy.

func wall_cling():
	velocity.y = lerp(velocity.y,0,0.2)
	jump_strength = 900
	wallmount = true
	if can_walljump:
		jump_count = 0
		can_walljump = false
		can_jump = true
				 
	if not is_on_wall() and not is_falling:
		jump_strength = 750
		wallmount = false
	if velocity.y > 0:
		rotation = 0

func GunTimer(phy):
	can_shoot = false
	var GunTimer = Timer.new()
	GunTimer.set_physics_process(phy)
	GunTimer.set_wait_time($Weapon/GunStats.cool_down)
	GunTimer.set_one_shot(true)
	self.add_child(GunTimer)
	GunTimer.start()
	
	yield(GunTimer, "timeout")
	GunTimer.queue_free()
	can_shoot = true
	
func Kickback(kickback):
	velocity = Vector2(kickback, 0).rotated($Weapon.global_rotation)
	
func take_damage(amount, weapon, damager, impact_pos=global_position, weapon_rot=global_rotation):
	health -= amount
	emit_signal("health_changed", (health * 100 / max_health))
	rpc("spew_blood", impact_pos, weapon_rot)
	if health <= 0:
		rpc("die")
		get_node("/root/GameController").rpc("who_died", username, weapon, damager)
		
sync func die():
	emit_signal("died")
	hide()
	set_physics_process(false)
	can_shoot = false
	$Camera2D._set_current(false)
#	$CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.disabled = true 
	# this won't work while flushing queries, but changing it via set_deferred will make the player take 50 damage as soon as they respawn.
	$BloodGore/GibSound.play()
	
sync func spew_blood(pos, rot):
	var rng = RandomNumberGenerator.new()
	
	rng.randomize()
	var number = rng.randi_range(1,3)
	if number == 1:
		$BloodGore/BloodSound1.play()
	elif number == 2:
		$BloodGore/BloodSound2.play()
	elif number == 3:
		$BloodGore/BloodSound3.play()

	var blood_emitter = load("res://misc/BloodSpurt.tscn").instance()
	$BloodGore.add_child(blood_emitter)
	blood_emitter.global_position = pos
	blood_emitter.global_rotation = rng.randf_range((rot + PI) - 1, rot + PI)
	blood_emitter.emitting = true
	$BloodGore/BloodTimer.start(blood_emitter.lifetime)
	yield($BloodGore/BloodTimer, "timeout")
	blood_emitter.queue_free()
	
sync func respawn():
	show()
	set_physics_process(true)
	can_shoot = true
	$CollisionShape2D.disabled = false
	health = max_health
	emit_signal("respawn")

func _on_GrappleTimer_timeout():
	get_parent().get_node("CanvasLayer/HUD/GrappleCooldown").hide()
	$GrappleTimer.stop()
	can_grapple = true

func _on_WallJumpTimer_timeout():
	can_doublejump = true

func _ChainHook():
	chain_velocity = to_local($Chain.tip).normalized() * chain_pull
	if chain_velocity.y > 0:
		# Pulling down isn't as strong
		chain_velocity.y *= 1.65
	else:
		# Pulling up is stronger
		chain_velocity.y *= 1.65
