extends Node2D

export (PackedScene) var Bullet

var is_automatic
var is_burst_fire
var is_semi_auto
var shotgun
var kickback = 0
var damage

var cool_down = 0.5
#cool_down time for each shot, could also be reload time and effects the time in betwene shots of auto fire

var burst_ammount = 3
#how many bullets are shot in one burst

var bullet_size = Vector2(0.2,0.2) #default is 0.2
var bullet_speed = 3000
var bullet_lifetime
var weapon_sprite
var weapon_size = Vector2(2,2)
var weapon_position = Vector2(0,0)

var assault_sound
var m1_sound
var super_shotgun_sound
var pistol_sound  

var mag = 50
var shots_fired = 50
var can_fire = true
var ReloadTime = 2

func spawn_projectile(pos, dir, dmg, speed, type, size, lifetime):
    var new_projectile = Bullet.instance()
    new_projectile.set_position(pos)
    new_projectile.velocity = Vector2(speed, 0).rotated(dir)
    new_projectile.damage = dmg
    new_projectile.get_node("Sprite").animation = type
    new_projectile.get_node("Sprite").set_rotation(dir)
    new_projectile.get_node("Sprite").set_scale(size)
    new_projectile.get_node("Explosion").set_scale(size)
    new_projectile.add_to_group("bullets")
    $Bullets.add_child(new_projectile)

func _BulletPostition():
    if can_fire:
        shots_fired -= 1
        if shots_fired == 0:
            can_fire = false   
        if $RayCast2DKick.is_colliding():
            get_parent().get_parent().Kickback(kickback)
        if not shotgun:
            spawn_projectile(
                        get_parent().get_node("Weapon_Sprite/Muzzle").global_position, 
                        get_parent().global_rotation,
                        damage, 
                        bullet_speed, 
                        'blue', 
                        bullet_size, 
                        bullet_lifetime
                    )
        elif shotgun:
            var rot_amount = 0
            for _bullet in range(0,7):
                spawn_projectile(
                        get_parent().get_node("Weapon_Sprite/Muzzle").global_position, 
                        get_parent().global_rotation + rot_amount,
                        damage, 
                        bullet_speed, 
                        'blue', 
                        bullet_size, 
                        bullet_lifetime
                    )
                rot_amount -= 0.02
            $ShotDelayTimer.set_wait_time(0.03)
            $ShotDelayTimer.start()
            yield($ShotDelayTimer, "timeout")
        if assault_sound:
            $Sounds/Assault_fire.play()
        if pistol_sound:
            $Sounds/Pistol_fire.play()
        if m1_sound:
            $Sounds/M1_fire.play()
        if super_shotgun_sound:
            $Sounds/SuperShotgun_fire.play()
                
func set_sprite():
    get_parent().get_node("Weapon_Sprite").texture = get_parent().get_node("GunStats").weapon_sprite
    get_parent().get_node("Weapon_Sprite").scale = get_parent().get_node("GunStats").weapon_size
    get_parent().get_node("Weapon_Sprite").position = get_parent().get_node("GunStats").weapon_position
