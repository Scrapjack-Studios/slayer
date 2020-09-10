extends Node

signal game_started
signal respawn_available
signal player_connection_completed
signal player_disconnection_completed

var player
var can_respawn
var wants_to_respawn
var map_node

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
    
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = player.health
    
    map_node = Global.map.trim_prefix("res://maps/")
    map_node = map_node.trim_suffix(".tscn")
    while not has_node(map_node):
        pass
    for body in get_tree().get_nodes_in_group("bodies"):
        if body is RigidBody2D:
            create_physics_puppet(body)
#            body.queue_free()

    emit_signal("game_started")
    
func _process(_delta):  
    if $CanvasLayer/DeathUI/RespawnCountdown.visible:
        $CanvasLayer/DeathUI/RespawnCountdown.set_text(str(int($CanvasLayer/DeathUI/RespawnTimer.time_left)))
    if player:
        $CanvasLayer/HUD/AmmoCounter.text = str(player.get_node("Weapon").get_node("GunStats").shots_fired)+"/"+str(player.get_node("Weapon").get_node("GunStats").mag)
    if player:
        $CanvasLayer/HUD/GrappleCooldown.value = player.get_node("GrappleTimer").get_time_left() * 25
    if player:
        $CanvasLayer/HUD/AmmoCooldown.value = player.get_node("Weapon").get_node("GunStats").get_node("ReloadTimer").time_left
    if player:
        $CanvasLayer/HUD/AmmoCooldown.max_value = player.get_node("Weapon").get_node("GunStats").get_node("ReloadTimer").wait_time
            
func create_physics_puppet(body):
    var body_pos
    var body_rot
    var body_collision_scale
    var body_collision_shape
    var body_sprite_texture
    
    body_pos = body.position
    body_rot = body.rotation
    for child in body.get_children():
        if child is CollisionShape2D:
            body_sprite_texture = child.get_child(0).texture
            body_collision_scale = child.scale
            body_collision_shape = child.shape

    var new_body = load("res://obstacles/PhysicsPuppet.tscn").instance()
    var new_body_collision = new_body.get_node("CollisionShape2D")
    var new_body_sprite = new_body.get_node("CollisionShape2D/Sprite")
    get_node(map_node).add_child(new_body)
    
    new_body.position = body_pos
    new_body.rotation = body_rot
    new_body_collision.scale = body_collision_scale
    new_body_collision.shape = body_collision_shape
#    new_body_sprite.texture = body_sprite_texture
        
func on_Player_health_changed(health):
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = health

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
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = player.health
    $CanvasLayer/DeathUI/RespawnAsker.hide()
    $CanvasLayer/DeathUI/RespawnCountdown.hide()
    
func spawn_peer(id):
    var info = Network.players[id]
    var new_player = load('res://Player.tscn').instance()
    new_player.name = str(id)
    new_player.set_network_master(id)
    add_child(new_player)
    new_player.init(info.name, info.position)
    
func on_Player_respawned():
    $CanvasLayer/HUD/HealthBar/TextureProgress.value = player.health
    player.get_node("Weapon/GunStats").shots_fired = player.get_node("Weapon/GunStats").mag
    player.set_position(Network.start_position)
    player.get_node("Camera2D").make_current()
    $CanvasLayer/DeathUI/RespawnAsker.hide()
    $CanvasLayer/DeathUI/RespawnCountdown.hide()  
    
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
    print(Network.players)
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
        print(id)
        Network.players[id]["received_disconnect"] = true
        for disconnected_player in Network.players:
            if not Network.players[disconnected_player]["received_disconnect"]:
                return
        get_tree().set_network_peer(null)
        get_tree().change_scene("res://MainMenu.tscn")

func on_server_stopped():
    get_tree().change_scene("res://MainMenu.tscn")
