extends Node2D

export (PackedScene) var Bullet
export (int) var dmg

var is_automatic
var is_burst_fire
var is_semi_auto
var shotgun
var kickback = 1
var cool_down = 0
#cool_down time for each shot, could also be reload time and effects the time in betwene shots of auto fire
var burst_ammount = 3
#how many bullets are shot in one burst
var shotgun_pellets
var shotgun_spread = 0.1
var bullet_size = Vector2(0.3,0.3)
#default is 0.2
var bullet_speed = 3000
#velocity of bullet
var bullet_lifetime
var weapon_size = Vector2(4,4)
#weapon size
var weapon_position = Vector2(0,0)
#weapon location
var shot = false    
var assault_sound
var m1_sound
var super_shotgun_sound
var pistol_sound  
var mag = 50
var shots_fired = 50
var shots_fired_memory = 50
var can_fire = true
var ReloadTime = 2
var bounce
var area_effect

func fire():
	if can_fire:
		if shotgun:
			shots_fired -= 1
			effects()
			$Sounds/FireSound.rpc("play_firesound")
			rpc("spawn_projectile", "shotgun", get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation)
			if shots_fired == 0:
				can_fire = false 
		elif is_burst_fire:
			for bullet in burst_ammount: 
				shots_fired -= 1
				effects()
				$Sounds/FireSound.rpc("play_firesound")
				rpc("spawn_projectile", "burst_fire", get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation)
				if shots_fired == 0:
					can_fire = false    
		elif is_automatic:
			shots_fired -= 1
			effects()
			$Sounds/FireSound.rpc("play_firesound")
			rpc("spawn_projectile", "auto", get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation)
			if shots_fired == 0:
				can_fire = false
		elif is_semi_auto:
			shots_fired -= 1
			effects()
			$Sounds/FireSound.rpc("play_firesound")
			rpc("spawn_projectile", "semi_auto", get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation)
			if shots_fired == 0:
				can_fire = false

	  
sync func spawn_projectile(type, pos, rot):
	if type == "shotgun":
		for shotgun_pellet in shotgun_pellets:
			shotgun_spread =+ 0.5
			var pellet = Bullet.instance()
			pellet.start_at(pos, rot + rand_range(-0.05,0.05),'black', dmg, bullet_lifetime, bullet_size, bullet_speed, area_effect)
			$Bullets.add_child(pellet)
			if not is_network_master():
				pellet.set_collision_layer_bit(6, true)
	elif type == "burst_fire":
		var bullet = Bullet.instance()
		bullet.start_at(pos, rot,'black', dmg, bullet_lifetime, bullet_size, bullet_speed, area_effect)
		$Bullets.add_child(bullet)
		if not is_network_master():
			bullet.set_collision_layer_bit(6, true)
	elif type == "auto":
		var bullet = Bullet.instance()
		bullet.start_at(pos, rot,'black', dmg, bullet_lifetime, bullet_size, bullet_speed, area_effect)
		$Bullets.add_child(bullet)
		if not is_network_master():
			bullet.set_collision_layer_bit(6, true)
	elif type == "semi_auto":
		var bullet = Bullet.instance()
		bullet.start_at(pos, rot,'black', dmg, bullet_lifetime, bullet_size, bullet_speed, area_effect)
		$Bullets.add_child(bullet)
		if not is_network_master():
			bullet.set_collision_layer_bit(6, true)
						  
func set_sprite():
#    get_parent().get_node("Weapon_Sprite").texture = get_parent().get_node("GunStats").weapon_sprite
	get_parent().get_node("Weapon_Sprite").scale = get_parent().get_node("GunStats").weapon_size
#    get_parent().get_node("Weapon_Sprite").position = get_parent().get_node("GunStats").weapon_position

func effects():
	get_parent().get_node("Weapon_Sprite/Muzzle/Explosion").show()
	get_parent().get_node("Weapon_Sprite/Muzzle/Flash").show()
	$EffectsTimer.start(0.1)
	yield($EffectsTimer, "timeout")
	get_parent().get_node("Weapon_Sprite/Muzzle/Explosion").hide()
	get_parent().get_node("Weapon_Sprite/Muzzle/Flash").hide()




func check():
	if shots_fired == 0:
		can_fire = false
