extends Node

var player

func _ready():
    add_child($"/root/Global".map.instance())
    spawn()
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = player.health

func on_Player_health_changed(health):
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = health
    
func on_Player_died():
    player.queue_free()
    $CanvasLayer/DeathUI/YouDied.show()
    $CanvasLayer/DeathUI/YouDiedTimer.start()
    yield($CanvasLayer/DeathUI/YouDiedTimer, "timeout")
    $CanvasLayer/DeathUI/YouDied.hide()
    $CanvasLayer/DeathUI/RespawnAsker.show()

func _on_RespawnAsker_pressed():
    spawn()
    $CanvasLayer/DeathUI/RespawnAsker.hide()

func spawn():
    player = load("res://Player.tscn").instance()
    add_child(player)
    player.connect("health_changed", self, "on_Player_health_changed")
    player.connect("died", self, "on_Player_died")
    player.health = player.max_health
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = player.health
