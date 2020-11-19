extends Node2D

var Bullet
var dmg
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

func fire(type):
	if can_fire:
		match type:
			"shotgun":
				shots_fired -= 1
				effects()
				$Sounds/FireSound.play()
				for shotgun_pellet in shotgun_pellets:
					shotgun_spread =+ 0.5
					var pellet = Bullet.instance()
					pellet.spawn_projectile(
						get_parent().get_node("Weapon_Sprite/Muzzle").global_position, 
						get_parent().global_rotation + rand_range(-0.04,0.04),
						"black",
						dmg,
						bullet_lifetime, 
						bullet_size, 
						bullet_speed
					)
					$Bullets.add_child(pellet)
				if shots_fired == 0:
					can_fire = false 
			"burst_fire":
				for b in burst_ammount: 
					shots_fired -= 1
					effects()
					$Sounds/FireSound.play()
					var bullet = Bullet.instance()
					bullet.spawn_projectile(
						get_parent().get_node("Weapon_Sprite/Muzzle").global_position, 
						get_parent().global_rotation,
						"black",
						dmg, 
						bullet_lifetime, 
						bullet_size, 
						bullet_speed
					)
					$Bullets.add_child(bullet)
				if shots_fired == 0:
					can_fire = false
			"automatic":
				shots_fired -= 1
				effects()
				$Sounds/FireSound.play()
				var bullet = Bullet.instance()
				bullet.spawn_projectile(
					get_parent().get_node("Weapon_Sprite/Muzzle").global_position, 
					get_parent().global_rotation,
					"black",
					dmg, 
					bullet_lifetime, 
					bullet_size, 
					bullet_speed
				)
				$Bullets.add_child(bullet)
				if shots_fired == 0:
					can_fire = false
			"semi_auto":
				shots_fired -= 1
				effects()
				$Sounds/FireSound.play()
				var bullet = Bullet.instance()
				bullet.spawn_projectile(
					get_parent().get_node("Weapon_Sprite/Muzzle").global_position,
					get_parent().global_rotation,
					"black",
					dmg,
					bullet_lifetime,
					bullet_size,
					bullet_speed
				)
				$Bullets.add_child(bullet)
				if shots_fired == 0:
					can_fire = false

func set_sprite():
#    get_parent().get_node("Weapon_Sprite").texture = get_parent().get_node("GunStats").weapon_sprite
	get_parent().get_node("Weapon_Sprite").scale = get_parent().get_node("GunStats").weapon_size
#    get_parent().get_node("Weapon_Sprite").position = get_parent().get_node("GunStats").weapon_position

func effects():
	get_parent().get_node("Weapon_Sprite/Muzzle/Explosion").show()
	$EffectsTimer.start(0.1)
	yield($EffectsTimer, "timeout")
	get_parent().get_node("Weapon_Sprite/Muzzle/Explosion").hide()
