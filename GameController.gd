extends Node

signal game_started
signal respawn_available
signal player_connection_completed
signal player_disconnection_completed

var player
var can_respawn
var wants_to_respawn

func _ready():
    get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
    Network.connect("player_connection_completed", self, '_on_player_connection_completed')
    Network.connect("player_disconnection_completed", self, "on_player_disconnection_completed")
    Network.connect("server_stopped", self, "on_server_stopped")
    
    add_child(load(Global.map).instance())
    spawn_self()
    
    if not is_network_master():
        Network.rpc_id(1, '_request_players', get_tree().get_network_unique_id())
        for new_player in Network.players:
            if new_player != get_tree().get_network_unique_id():
                spawn_peer(new_player) 
    
    $CanvasLayer/HUD/HealthBar.value = player.health
    emit_signal("game_started")
    
func _process(_delta):
    if $CanvasLayer/DeathUI/RespawnCountdown.visible:
        $CanvasLayer/DeathUI/RespawnCountdown.set_text(str(int($CanvasLayer/DeathUI/RespawnTimer.time_left)))
    if player:
        $CanvasLayer/HUD/AmmoCounter.text = str(player.get_node("Weapon").get_node("GunStats").shots_fired)+"/"+str(player.get_node("Weapon").get_node("GunStats").mag)
        $CanvasLayer/HUD/GrappleCooldown.value = player.get_node("GrappleTimer").get_time_left() * 25
        $CanvasLayer/HUD/AmmoCooldown.value = player.get_node("Weapon").get_node("GunStats").get_node("ReloadTimer").time_left
        $CanvasLayer/HUD/AmmoCooldown.max_value = player.get_node("Weapon").get_node("GunStats").get_node("ReloadTimer").wait_time

func _on_RespawnAsker_pressed():
    if can_respawn:
        player.rpc("respawn")
    else:
        wants_to_respawn = true
        $CanvasLayer/DeathUI/RespawnAsker.set_text("Queued")

func spawn_self():
    player = load("res://Player.tscn").instance()
    player.name = str(get_tree().get_network_unique_id())
    player.set_network_master(get_tree().get_network_unique_id())
    add_child(player)
    player.init(Network.self_data.name, Network.start_position)
    player.connect("health_changed", self, "on_Player_health_changed")
    player.connect("died", self, "on_Player_died")
    player.connect("respawn", self, "on_Player_respawned")   
    player.health = player.max_health
    player.get_node("Camera2D").make_current()
    $CanvasLayer/HUD/HealthBar.value = player.health
    $CanvasLayer/HUD/HealthBar/HealthBarChange.value = player.health
    $CanvasLayer/DeathUI/RespawnAsker.hide()
    $CanvasLayer/DeathUI/RespawnCountdown.hide()
    
func spawn_peer(id):
    var info = Network.players[id]
    var new_player = load('res://Player.tscn').instance()
    new_player.set_collision_layer_bit(4, true)
    new_player.name = str(id)
    new_player.set_network_master(id)
    add_child(new_player)
    new_player.init(info.name, info.position)
    
remote func who_died(username):
    var obituary_row = load("res://menus/ObituaryRow.tscn").instance()
    $CanvasLayer/DeathUI/Obituary.add_child(obituary_row)
    obituary_row.get_node("Victim").text = username
    $CanvasLayer/DeathUI/Obituary/ObituaryRowTimeout.start()
    yield($CanvasLayer/DeathUI/Obituary/ObituaryRowTimeout, "timeout")
    obituary_row.queue_free()
    
func on_Player_died():
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
    
func on_Player_respawned():
    $CanvasLayer/HUD/HealthBar.value = player.health
    player.get_node("Weapon/GunStats").shots_fired = player.get_node("Weapon/GunStats").mag
    player.set_position(Network.start_position)
    player.get_node("Camera2D").make_current()
    $CanvasLayer/DeathUI/RespawnAsker.hide()
    $CanvasLayer/DeathUI/RespawnCountdown.hide()  
    
func on_Player_health_changed(health):
    $CanvasLayer/HUD/HealthBar.value = health
    $CanvasLayer/HUD/HealthBar/UpdateTween.interpolate_property($CanvasLayer/HUD/HealthBar/HealthBarChange, "value", $CanvasLayer/HUD/HealthBar/HealthBarChange.value, health, 0.6, Tween.TRANS_SINE, Tween.EASE_OUT, 0.4)
    $CanvasLayer/HUD/HealthBar/UpdateTween.start()
    
func _on_GameController_respawn_available():
    if wants_to_respawn:
        player.rpc("respawn")
        wants_to_respawn = false
        
func _on_player_disconnected(id):
    get_node(str(id)).queue_free()
    $CanvasLayer/NetworkUI/DisconnectMessage.set_text(Network.disconnected_player_info["name"] + " has disconnected")
    $CanvasLayer/NetworkUI/DisconnectMessageTimer.start()
    $CanvasLayer/NetworkUI/DisconnectMessage.show()
    yield($CanvasLayer/NetworkUI/DisconnectMessageTimer, "timeout")
    $CanvasLayer/NetworkUI/DisconnectMessage.hide()
    
func _on_player_connection_completed():
    if get_tree().get_network_unique_id() != Network.connected_player:
        spawn_peer(Network.connected_player)
    elif get_tree().get_network_unique_id() != Network.connected_player and Network.connected_player != 1:
        $CanvasLayer/NetworkUI/ConnectMessage.set_text(Network.connected_player_info["name"] + " has connected")
        $CanvasLayer/NetworkUI/ConnectMessageTimer.start()
        $CanvasLayer/NetworkUI/ConnectMessage.show()
        yield($CanvasLayer/NetworkUI/ConnectMessageTimer, "timeout")
        $CanvasLayer/NetworkUI/ConnectMessage.hide()
        
func on_player_disconnection_completed(id):
    if is_network_master():
        Network.players[id]["received_disconnect"] = true
        for disconnected_player in Network.players:
            if not Network.players[disconnected_player]["received_disconnect"]:
                return
        get_tree().set_network_peer(null)
        get_tree().change_scene("res://MainMenu.tscn")

func on_server_stopped():
    get_tree().change_scene("res://MainMenu.tscn")
