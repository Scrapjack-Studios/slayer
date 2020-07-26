extends Node

signal respawn_available

var player
var can_respawn
var wants_to_respawn
var respawning_player

func _ready():
    # warning-ignore:return_value_discarded
    get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
    # warning-ignore:return_value_discarded
    get_tree().connect('server_disconnected', self, '_on_server_disconnected')
    
    add_child($"/root/Global".map.instance())
    spawn()
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = player.health
    
func _process(_delta):
    if $CanvasLayer/DeathUI/RespawnCountdown.visible:
        $CanvasLayer/DeathUI/RespawnCountdown.set_text(str(int($CanvasLayer/DeathUI/RespawnTimer.time_left)))

func on_Player_health_changed(health):
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = health

func _on_RespawnAsker_pressed():
    if can_respawn:
        rpc("respawn", respawning_player)
    else:
        wants_to_respawn = true
        $CanvasLayer/DeathUI/RespawnAsker.set_text("Queued")

func spawn():
    player = load("res://Player.tscn").instance()
    player.name = str(get_tree().get_network_unique_id())
    player.set_network_master(get_tree().get_network_unique_id())
    add_child(player)
    var info = Network.self_data
    player.init(info.name, Vector2(500,480))
    player.connect("health_changed", self, "on_Player_health_changed")
    player.health = player.max_health
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = player.health
    $CanvasLayer/DeathUI/RespawnAsker.hide()
    $CanvasLayer/DeathUI/RespawnCountdown.hide()
    
sync func respawn(player_to_respawn):
    player_to_respawn.show()
    player_to_respawn.set_physics_process(true)
    player_to_respawn.can_shoot = true
    player_to_respawn.get_node("Camera2D")._set_current(true)
    player_to_respawn.set_position(Vector2(500,480))
    player_to_respawn.health = player_to_respawn.max_health
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = player_to_respawn.health
    $CanvasLayer/DeathUI/RespawnAsker.hide()
    $CanvasLayer/DeathUI/RespawnCountdown.hide()
    
sync func die(dead_player):
    dead_player.hide()
    dead_player.set_physics_process(false)
    dead_player.can_shoot = false
    dead_player.get_node("Camera2D")._set_current(false)
    respawning_player = dead_player
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
    
func _on_GameController_respawn_available():
    if wants_to_respawn:
        rpc("respawn", respawning_player)
        wants_to_respawn = false
        
func _on_player_disconnected(id):
    get_node(str(id)).queue_free()
    $CanvasLayer/NetworkUI/DisconnectMessage.set_text(str(id) + " has disconnected")
    $CanvasLayer/NetworkUI/DisconnectMessageTimer.start()
    $CanvasLayer/NetworkUI/DisconnectMessage.show()
    yield($CanvasLayer/NetworkUI/DisconnectMessageTimer, "timeout")
    $CanvasLayer/NetworkUI/DisconnectMessage.hide()

func _on_server_disconnected():
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://MainMenu.tscn")
