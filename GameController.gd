extends Node

signal respawn_available

const INTERPOLATION_OFFSET = 100

var player_scene = preload("res://Player.tscn")
var other_player_scene = preload("res://player/OtherPlayer.tscn")
var last_world_state = 0
var player
var can_respawn
var wants_to_respawn

# [MostRecentPast, NearestFuture, AnyOtherFuture]
var world_state_buffer = []

func _ready():
	add_child(load("res://maps/" + Global.map + ".tscn").instance())
	spawn_self(str(get_tree().get_network_unique_id()))

func _process(_delta):
	if $CanvasLayer/DeathUI/RespawnCountdown.visible:
		$CanvasLayer/DeathUI/RespawnCountdown.set_text(str(int($CanvasLayer/DeathUI/RespawnTimer.time_left)))
	if player:
		$CanvasLayer/HUD/AmmoCounter.text = str(player.get_node("Weapon").get_node("GunStats").shots_fired)+"/"+str(player.get_node("Weapon").get_node("GunStats").mag)
		$CanvasLayer/HUD/GrappleCooldown.value = player.get_node("GrappleTimer").get_time_left() * 25
		$CanvasLayer/HUD/AmmoCooldown.value = player.get_node("Weapon").get_node("GunStats").get_node("ReloadTimer").time_left
		$CanvasLayer/HUD/AmmoCooldown.max_value
		player.get_node("Weapon").get_node("GunStats").get_node("ReloadTimer").wait_time

func _physics_process(delta: float) -> void:
	# time of the frame being rendered
	var render_time = OS.get_system_time_msecs() - INTERPOLATION_OFFSET
	# check if buffer has at least 2 world states
	if world_state_buffer.size() > 1:
		# check if the render time is further along than the nearest future state in the buffer
		# if the render_time is further along, then the nearest future state is no longer in the future
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[1].T:
			# remove most recent past world state, b/c it's no longer no longer useful
			# this shifts the previous nearest future state to the past in the array
			world_state_buffer.remove(0)
		# determine how much time has passed (as %) from past to future state
		# if we're close to the future state we want the position to be closer to future state
		# if we're closer to the past world state, we use that instead
		var past_to_present_lapse = float(render_time - world_state_buffer[0].T)
		var past_present_difference = float(world_state_buffer[1].T - world_state_buffer[0].T)
		var interpolation_factor =  past_to_present_lapse / past_present_difference
		# loop over every player in world state, and determine their position based on render time
		for player in world_state_buffer[1].keys():
			if str(player) == "T":
				continue
			# don't operate on your own network ID
			elif player == get_tree().get_network_unique_id():
				continue
			# make sure the player actually has a past world state
			elif not world_state_buffer[0].has(player):
				continue
			elif $Players.has_node(str(player)):
				var new_position = lerp(world_state_buffer[0][player].P, world_state_buffer[1][player].P, interpolation_factor)
				$Players.get_node(str(player)).set_position(new_position)
			else:
				print("Spawning new player.")
				spawn(player, world_state_buffer[1][player].P)

func update_world_state(world_state):
	# check if world state is up-to-date
	if world_state["T"] > last_world_state: 
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)

func spawn(id, start_position):
	if get_tree().get_network_unique_id() == id:
		pass
	elif not $Players.has_node(str(id)):
		var new_player = other_player_scene.instance()
		new_player.position = start_position
		new_player.name = str(id)
		new_player.username = str(id)
		$Players.add_child(new_player)

func despawn(id):
	$Players.get_node(str(id)).queue_free()

func spawn_self(id):
	player = player_scene.instance()
	$Players.add_child(player)
	player.position = Vector2(0,0)
	player.name = str(id)
	player.username = str(id)
	player.connect("health_changed", self, "on_Player_health_changed")
	player.connect("died", self, "on_Player_died")
	player.connect("respawn", self, "on_Player_respawned")   
	player.health = player.max_health
	player.get_node("Camera2D").make_current()
	$CanvasLayer/HUD/HealthBar.value = player.health
	$CanvasLayer/HUD/HealthBar/HealthBarChange.value = player.health
	$CanvasLayer/DeathUI/RespawnAsker.hide()
	$CanvasLayer/DeathUI/RespawnCountdown.hide()

remote func who_died(victim, weapon_sprite, killer):
	var obituary_row = load("res://menus/ObituaryRow.tscn").instance()
	$CanvasLayer/DeathUI/Obituary.add_child(obituary_row)
	obituary_row.get_node("Killer").text = killer
	obituary_row.get_node("Weapon").texture = load(weapon_sprite)
	obituary_row.get_node("Victim").text = victim
	
	$CanvasLayer/DeathUI/Obituary/ObituaryRowTimeout.start()
	yield($CanvasLayer/DeathUI/Obituary/ObituaryRowTimeout, "timeout")
	obituary_row.queue_free()
	
func on_Player_died():
	$CanvasLayer/DeathUI/YouDied.show()
	$CanvasLayer/DeathUI/Weapons.show()
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
	player.set_position(Server.start_position)
	player.get_node("Camera2D").make_current()
	$CanvasLayer/DeathUI/RespawnAsker.hide()
	$CanvasLayer/DeathUI/Weapons.hide()
	$CanvasLayer/DeathUI/RespawnCountdown.hide()  
	Global.weapon1 = $CanvasLayer/DeathUI/Weapons/Weapon1.get_item_text($CanvasLayer/DeathUI/Weapons/Weapon1.selected)
	Global.weapon2 = $CanvasLayer/DeathUI/Weapons/Weapon2.get_item_text($CanvasLayer/DeathUI/Weapons/Weapon2.selected)
	Global.weapon3 = $CanvasLayer/DeathUI/Weapons/Weapon3.get_item_text($CanvasLayer/DeathUI/Weapons/Weapon3.selected)
	Global.weapon4 = $CanvasLayer/DeathUI/Weapons/Weapon4.get_item_text($CanvasLayer/DeathUI/Weapons/Weapon4.selected)
	
func on_Player_health_changed(health):
	$CanvasLayer/HUD/HealthBar.value = health
	$CanvasLayer/HUD/HealthBar/UpdateTween.interpolate_property($CanvasLayer/HUD/HealthBar/HealthBarChange, "value", $CanvasLayer/HUD/HealthBar/HealthBarChange.value, health, 0.6, Tween.TRANS_SINE, Tween.EASE_OUT, 0.4)
	$CanvasLayer/HUD/HealthBar/UpdateTween.start()
	
func _on_GameController_respawn_available():
	if wants_to_respawn:
		player.rpc("respawn")
		wants_to_respawn = false

func _on_RespawnAsker_pressed():
	if can_respawn:
		Global.player_node.rpc("respawn")
	else:
		wants_to_respawn = true
		$CanvasLayer/DeathUI/RespawnAsker.set_text("Queued")

#func _on_player_disconnected(id):
#	get_node(str(id)).queue_free()
#	$CanvasLayer/NetworkUI/DisconnectMessage.set_text(Server.disconnected_player_info["name"] + " has disconnected")
#	$CanvasLayer/NetworkUI/DisconnectMessageTimer.start()
#	$CanvasLayer/NetworkUI/DisconnectMessage.show()
#	yield($CanvasLayer/NetworkUI/DisconnectMessageTimer, "timeout")
#	$CanvasLayer/NetworkUI/DisconnectMessage.hide()
	
#func on_player_connection_completed():
#	if get_tree().get_network_unique_id() != Server.connected_player:
#		spawn_peer(Server.connected_player)
#	elif get_tree().get_network_unique_id() != Server.connected_player:
#		$CanvasLayer/NetworkUI/ConnectMessage.set_text(Server.connected_player_info["name"] + " has connected")
#		$CanvasLayer/NetworkUI/ConnectMessageTimer.start()
#		$CanvasLayer/NetworkUI/ConnectMessage.show()
#		yield($CanvasLayer/NetworkUI/ConnectMessageTimer, "timeout")
#		$CanvasLayer/NetworkUI/ConnectMessage.hide()
		
#func on_player_disconnection_completed(id):
#	if is_network_master():
#		Network.players[id]["received_disconnect"] = true
#		for disconnected_player in Network.players:
#			if not Network.players[disconnected_player]["received_disconnect"]:
#				return
#		get_tree().set_network_peer(null)
#		get_tree().change_scene("res://MainMenu.tscn")

func on_server_stopped():
	get_tree().change_scene("res://MainMenu.tscn")
