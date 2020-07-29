extends Node

#export (PackedScene) var GunStats

#should set values in res://GunStats.gd

func activate():
    get_parent().get_parent().get_parent().get_node("GunStats").is_semi_auto = false
    get_parent().get_parent().get_parent().get_node("GunStats").is_automatic = true
    get_parent().get_parent().get_parent().get_node("GunStats").is_burst_fire = false
    get_parent().get_parent().get_parent().get_node("GunStats").shotgun = false
    get_parent().get_parent().get_parent().get_node("GunStats").assault_sound = true
    get_parent().get_parent().get_parent().get_node("GunStats").cool_down = 0.07
    get_parent().get_parent().get_parent().get_node("GunStats").weapon_sprite = load("res://assets/sprites/weapons/AssaultRifle.png")
    get_parent().get_parent().get_parent().get_node("GunStats").mag = 50
    get_parent().get_parent().get_parent().get_node("GunStats").kickback = 0
    get_parent().get_parent().get_node("RayCast2DKick").set_enabled(false)
