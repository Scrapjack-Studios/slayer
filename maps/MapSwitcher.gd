extends Node

var map = load("res://maps/ShootingRange.tscn")

func _ready():
    add_child(map.instance())
