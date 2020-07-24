extends Node

signal respawn_available

var player
var can_respawn
var wants_to_respawn

func _ready():
    get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
    get_tree().connect('server_disconnected', self, '_on_server_disconnected')
    
    add_child($"/root/Global".map.instance())
    spawn()
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = player.health
    
func _process(_delta):
    if $CanvasLayer/DeathUI/RespawnCountdown.visible:
        $CanvasLayer/DeathUI/RespawnCountdown.set_text(str(int($CanvasLayer/DeathUI/RespawnTimer.time_left)))

func on_Player_health_changed(health):
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = health
    
func on_Player_died():
    player.queue_free()
    $CanvasLayer/DeathUI/YouDied.show()
    $CanvasLayer/DeathUI/YouDiedTimer.start()
    yield($CanvasLayer/DeathUI/YouDiedTimer, "timeout")
    $CanvasLayer/DeathUI/YouDied.hide()
    $CanvasLayer/DeathUI/RespawnAsker.show()
    $CanvasLayer/DeathUI/RespawnAsker.set_text("Respawn")
    can_respawn = false
    $CanvasLayer/DeathUI/RespawnTimer.start()
    $CanvasLayer/DeathUI/RespawnCountdown.show()
    yield($CanvasLayer/DeathUI/RespawnTimer, "timeout")
    can_respawn = true
    emit_signal("respawn_available")

func _on_RespawnAsker_pressed():
    if can_respawn:
        spawn()
    else:
        wants_to_respawn = true
        $CanvasLayer/DeathUI/RespawnAsker.set_text("Queued")

func spawn():
    player = load("res://Player.tscn").instance()
    player.name = str(get_tree().get_network_unique_id())
    player.set_network_master(get_tree().get_network_unique_id())
    add_child(player)
    var info = Network.self_data
    player.set_position(info.position)
    player.connect("health_changed", self, "on_Player_health_changed")
    player.connect("died", self, "on_Player_died")
    player.health = player.max_health
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = player.health
    $CanvasLayer/DeathUI/RespawnAsker.hide()
    $CanvasLayer/DeathUI/RespawnCountdown.hide()


func _on_GameController_respawn_available():
    if wants_to_respawn:
        spawn()
        wants_to_respawn = false
