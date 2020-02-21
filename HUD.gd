extends MarginContainer

func _on_health_changed(health):
	$HealthBar/TextureProgress.value = health