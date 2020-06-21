extends Node

export (PackedScene) var GunStats

func _ready():
    var b = GunStats.instance()
    b.readyfire(false, true, false ,false)
