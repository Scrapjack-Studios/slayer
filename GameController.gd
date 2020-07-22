extends Node

var player = load("res://Player.tscn")

func _ready():
    add_child($"/root/Global".map.instance())
    add_child(player.instance())
    
    # warning-ignore:return_value_discarded
    $Player.connect("health_changed", self, "on_Player_health_changed")
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = $Player.health

func on_Player_health_changed(health):
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = health
