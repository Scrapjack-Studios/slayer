extends Control

var map

remote func set_client_map(new_map):
    Global.map = new_map
    get_tree().change_scene("res://GameController.tscn")
