extends Node2D

export (PackedScene) var Bullet
export (int) var dmg

var is_automatic
var is_burst_fire
var is_semi_auto
var shotgun
var kickback = -500


var cool_down = 0.5
#cool_down time for each shot, could also be reload time and effects the time in betwene shots of auto fire

var burst_ammount = 3
#how many bullets are shot in one burst


var auto_mag = 60

var bullet_size = Vector2(0.3,0.3)
#default is 0.2

var bullet_speed = 3000
#velocity of bullet

var bullet_lifetime

var weapon_sprite
#Weapon sprite duh

var weapon_size = Vector2(2,2)
#weapon size

var weapon_position = Vector2(0,0)
#weapon location
var shot = false    

var assault_sound
var combat_shotgun_sound
var super_shotgun_sound
var pistol_sound  
    
    
func _BulletPostition():
    var b = Bullet.instance()
    b.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
    $Bullets.add_child(b)
    shot = true
    get_parent().get_parent().Kickback(kickback)
    
    if shotgun:
        var c = Bullet.instance()
        var d = Bullet.instance()
        var e = Bullet.instance()
        var f = Bullet.instance()
        var g = Bullet.instance()
        var h = Bullet.instance()
        c.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation + 0.04,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
        d.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation + 0.03,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
        e.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation + 0.01,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
        f.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation - 0.01,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
        g.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation - 0.03,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
        h.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation - 0.04,'blue', dmg, bullet_lifetime, bullet_size, bullet_speed)
        $Bullets.add_child(c)
        $Bullets.add_child(e)
        $Bullets.add_child(g)
        var t = Timer.new()
        t.set_wait_time(0.03)
        t.set_one_shot(true)
        self.add_child(t)
        t.start()
        yield(t, "timeout")
        $Bullets.add_child(d)
        $Bullets.add_child(f)
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

func set_sprite():
    get_parent().get_node("Weapon_Sprite").texture = get_parent().get_node("GunStats").weapon_sprite
    get_parent().get_node("Weapon_Sprite").scale = get_parent().get_node("GunStats").weapon_size
    get_parent().get_node("Weapon_Sprite").position = get_parent().get_node("GunStats").weapon_position
