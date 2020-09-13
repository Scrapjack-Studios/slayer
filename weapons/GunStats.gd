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
var shotgun_spread = 0
var bullet_size = Vector2(0.3,0.3)
#default is 0.2
var bullet_speed = 3000
#velocity of bullet
var bullet_lifetime
var weapon_size = Vector2(2,2)
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

func bulletstats():
    if can_fire:
        print("bulletstats")
        rpc("fire")
        shots_fired -= 1
        if shots_fired == 0:
            can_fire = false
        if shot:
            effects()
        
sync func fire():
    
    if shotgun:
        shot = true
        $Sounds/FireSound.play()
        for i in shotgun_pellets:
            var c = Bullet.instance()
            c.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation + shotgun_spread,'black', dmg, bullet_lifetime, bullet_size, bullet_speed)
            $Bullets.add_child(c)
            shotgun_spread =+ 0.01
            
    if is_burst_fire:
        for i in burst_ammount: 
            var c = Bullet.instance()
            c.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation,'black', dmg, bullet_lifetime, bullet_size, bullet_speed)
            $Bullets.add_child(c)
            shot = true
            $Sounds/FireSound.play()
            var t = Timer.new()
            t.set_wait_time(0.1)
            t.set_one_shot(true)
            self.add_child(t)
            t.start()
            yield(t, "timeout")
            t.queue_free()
            
    if is_automatic:
        var c = Bullet.instance()
        c.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation,'black', dmg, bullet_lifetime, bullet_size, bullet_speed)
        $Bullets.add_child(c)
        shot = true
        $Sounds/FireSound.play()
        
    if is_semi_auto:
        var c = Bullet.instance()
        c.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation,'black', dmg, bullet_lifetime, bullet_size, bullet_speed)
        $Bullets.add_child(c)
        shot = true
        $Sounds/FireSound.play()
                
                          
func set_sprite():
#    get_parent().get_node("Weapon_Sprite").texture = get_parent().get_node("GunStats").weapon_sprite
    get_parent().get_node("Weapon_Sprite").scale = get_parent().get_node("GunStats").weapon_size
#    get_parent().get_node("Weapon_Sprite").position = get_parent().get_node("GunStats").weapon_position

func effects():
    get_parent().get_node("Weapon_Sprite/Muzzle/Explosion").show()
    var t = Timer.new()
    t.set_wait_time(0.1)
    t.set_one_shot(true)
    self.add_child(t)
    t.start()
    yield(t, "timeout")
    t.queue_free()
    get_parent().get_node("Weapon_Sprite/Muzzle/Explosion").hide()
    get_parent().get_node("Weapon_Sprite/Muzzle/Smoke").set_emitting(true)
    var t1 = Timer.new()
    t1.set_wait_time(1)
    t1.set_one_shot(true)
    self.add_child(t1)
    t1.start()
    yield(t1, "timeout")
    t1.queue_free()
    get_parent().get_node("Weapon_Sprite/Muzzle/Smoke").set_emitting(false)





