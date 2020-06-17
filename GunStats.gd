extends Node2D

export (PackedScene) var Bullet
export (int) var dmg

export (bool) var is_automatic
export (bool) var is_burst
export (bool) var is_semi_auto
#only of these can be set to true


export (bool) var shotgun
#does nothing at the moment

export (float) var cool_down
#cool_down time for each shot, could also be reload time and effects the time in betwene shots of auto fire

export (int) var burst_ammount
#how many bullets are shot in one burst

export (int) var auto_mag

export (Vector2) var bullet_size
#default is 0.2

export (int) var bullet_speed
#velocity of bullet

var bullet_lifetime

export (Texture) var weapon_sprite
#Weapon sprite duh

export (Vector2) var weapon_size
#weapon size

export (Vector2) var weapon_position
#weapon location

var assault_sound
var combat_shotgun_sound
var super_shotgun_sound
var pistol_sound

export (int) var sound
func _ready():
    if sound == 1:
        assault_sound = true
    if sound == 2:
        combat_shotgun_sound = true
    if sound == 3:
        super_shotgun_sound = true
    if sound == 4:
        pistol_sound = true


var shot = false    


    


func _BulletPostition():
    var b = Bullet.instance()
    b.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
    $Bullets.add_child(b)
    shot = true
    if shotgun:
        var c = Bullet.instance()
        var d = Bullet.instance()
        var e = Bullet.instance()
        var f = Bullet.instance()
        var g = Bullet.instance()
        var h = Bullet.instance()
        c.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation + 0.05,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
        d.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation + 0.04,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
        e.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation + 0.02,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
        f.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation - 0.02,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
        g.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation - 0.04,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
        h.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation - 0.05,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
        $Bullets.add_child(c)
        $Bullets.add_child(d)
        $Bullets.add_child(e)
        $Bullets.add_child(f)
        $Bullets.add_child(g)
        $Bullets.add_child(h)
        

    if shot:
        
        if assault_sound:
            $Sounds/Assault_fire.play()
            shot = false
        if pistol_sound:
            $Sounds/Pistol_fire.play()
            shot = false
        if combat_shotgun_sound:
            $Sounds/CombatShotgun_fire.play()
            shot = false
        if super_shotgun_sound:
            $Sounds/SuperShotgun_fire.play()
            shot = false
