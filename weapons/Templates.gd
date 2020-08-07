extends Node2D

var weapon_list


func _enter_tree():
    weapon_list = get_children()
