extends Node

class_name weapon_setter

export (bool) var semi_auto
export (bool) var automatic
export (bool) var burst_fire
export (bool) var shotgun
export (int) var cool_down
export (int) var mag
export (int) var shots_fired
export (int) var reload
export (Texture) var weapon_sprite 
export (int) var kickback
export (int) var burst_ammount
export (bool) var assault_sound
export (bool) var m1_sound
export (bool) var super_shotgun_sound
export (bool) var pistol_sound  
export (int) var dmg

func activate():
    get_parent().get_parent().get_parent().get_node("GunStats").dmg = dmg
    get_parent().get_parent().get_parent().get_node("GunStats").is_semi_auto = semi_auto
    get_parent().get_parent().get_parent().get_node("GunStats").is_automatic = automatic
    get_parent().get_parent().get_parent().get_node("GunStats").is_burst_fire = burst_fire
    get_parent().get_parent().get_parent().get_node("GunStats").shotgun = shotgun
    get_parent().get_parent().get_parent().get_node("GunStats").burst_ammount = burst_ammount
    get_parent().get_parent().get_parent().get_node("GunStats").cool_down = cool_down
    get_parent().get_parent().get_parent().get_node("GunStats").weapon_sprite = weapon_sprite
    get_parent().get_parent().get_parent().get_node("GunStats").mag = mag
    get_parent().get_parent().get_parent().get_node("GunStats").shots_fired = shots_fired
    get_parent().get_parent().get_parent().get_node("GunStats").kickback = kickback
    get_parent().get_parent().get_parent().get_node("GunStats").pistol_sound = pistol_sound  
    get_parent().get_parent().get_parent().get_node("GunStats").super_shotgun_sound = super_shotgun_sound
    get_parent().get_parent().get_parent().get_node("GunStats").m1_sound = m1_sound
    get_parent().get_parent().get_parent().get_node("GunStats").assault_sound = assault_sound
    


