extends Node

#export (PackedScene) var GunStats

#should set values in res://GunStats.gd

func activate():
    get_parent().get_parent().get_parent().get_node("GunStats").is_semi_auto = false
    get_parent().get_parent().get_parent().get_node("GunStats").is_automatic = true
    get_parent().get_parent().get_parent().get_node("GunStats").is_burst_fire = false
    get_parent().get_parent().get_parent().get_node("GunStats").shotgun = false
    get_parent().get_parent().get_parent().get_node("GunStats").pistol_sound = true
    get_parent().get_parent().get_parent().get_node("GunStats").cool_down = 0.15
    get_parent().get_parent().get_parent().get_node("GunStats").weapon_sprite = load("res://assets/sprites/weapons/AssaultRifle.png")
    get_parent().get_parent().get_parent().get_node("GunStats").kickback = -100
