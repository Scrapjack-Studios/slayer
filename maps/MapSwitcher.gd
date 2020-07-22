extends Node

func _ready():
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = $Player.health
    add_child($"/root/Global".map.instance())
    # warning-ignore:return_value_discarded
    $Player.connect("health_changed", self, "on_Player_health_changed()")

func _on_Player_health_changed(health):
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = health
