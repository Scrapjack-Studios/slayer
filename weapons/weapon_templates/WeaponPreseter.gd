extends Node

class_name weapon_setter

export (bool) var semi_auto
export (bool) var automatic
export (bool) var burst_fire
export (bool) var shotgun
export (float) var cool_down
export (int) var mag
export (int) var shots_fired
export (int) var reload
export (Texture) var weapon_sprite 
export (int) var kickback
export (int) var burst_ammount
export (int) var dmg
export(int, "Pistol", "Assault", "Shotgun", "Carbine") var Weapon_Sounds



func activate():
    get_parent().get_parent().get_parent().get_node("GunStats").get_node("Sounds/FireSound").shotgun = Weapon_Sounds == 2
    get_parent().get_parent().get_parent().get_node("GunStats").get_node("Sounds/FireSound").pistol = Weapon_Sounds == 0
    get_parent().get_parent().get_parent().get_node("GunStats").get_node("Sounds/FireSound").assault = Weapon_Sounds == 1
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


