extends MarginContainer

func _on_Player_health_changed(health):
    $HealthBar/TextureProgress.value = health
