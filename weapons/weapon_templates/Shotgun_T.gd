extends Node

export (PackedScene) var GunStats

#should set values in res://GunStats.gd

func activate():
    get_parent().get_parent().get_parent().get_node("GunStats").is_semi_auto = false
    get_parent().get_parent().get_parent().get_node("GunStats").is_automatic = false
    get_parent().get_parent().get_parent().get_node("GunStats").is_burst_fire = false
    get_parent().get_parent().get_parent().get_node("GunStats").shotgun = true
    get_parent().get_parent().get_parent().get_node("GunStats").combat_shotgun_sound = true
    get_parent().get_parent().get_parent().get_node("GunStats").cool_down = 1
