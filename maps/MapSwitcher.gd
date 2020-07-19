extends Node

func _ready():
    add_child($"/root/Global".map.instance())
