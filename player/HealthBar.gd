extends ProgressBar

func on_Player_health_changed(health):
    value = health
    print(health)
    $UpdateTween.interpolate_property($HealthBarChange, "value", $HealthBarChange.value, health, 0.6, Tween.TRANS_SINE, Tween.EASE_OUT, 0.4)
    $UpdateTween.start()
