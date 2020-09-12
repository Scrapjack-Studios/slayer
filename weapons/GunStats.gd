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
var m1_sound
var super_shotgun_sound
var pistol_sound  

var mag = 50
master var shots_fired
master var shots_fired_memory
master var can_fire = true
var ReloadTime = 2
var bounce

    
    
sync func _BulletPostition():
    if can_fire:
        var b = Bullet.instance()
        b.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation,'black', dmg, bullet_lifetime, bullet_size, bullet_speed)
        $Bullets.add_child(b)
        rset("shots_fired", shots_fired - 1)
        rset("shots_fired_memory", shots_fired_memory - 1)
        shot = true
        if shots_fired == 0:
            rset("can_fire", false)   
        if $RayCast2DKick.is_colliding():
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
   
        if is_burst_fire:
            for i in burst_ammount: 
                var c = Bullet.instance()
                c.start_at(get_parent().get_node("Weapon_Sprite/Muzzle").global_position, get_parent().global_rotation,'black', dmg, bullet_lifetime, bullet_size, bullet_speed)
                $Bullets.add_child(c)
                var t = Timer.new()
                t.set_wait_time(0.005)
                t.set_one_shot(true)
                self.add_child(t)
                t.start()
                yield(t, "timeout")
                t.queue_free()
                $Sounds/FireSound.play()
                  
        if shot:
            $Sounds/FireSound.play()
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
            
func set_sprite():
#    get_parent().get_node("Weapon_Sprite").texture = get_parent().get_node("GunStats").weapon_sprite
#    get_parent().get_node("Weapon_Sprite").scale = get_parent().get_node("GunStats").weapon_size
#    get_parent().get_node("Weapon_Sprite").position = get_parent().get_node("GunStats").weapon_position
    shots_fired_memory = shots_fired








