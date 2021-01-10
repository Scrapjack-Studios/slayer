extends Node

var client_clock
var decimal_collector: float = 0
var latency_array = []
var latency = 0
var delta_latency = 0

func _physics_process(delta: float) -> void: # expected delta: 0.01667
	# convert delta value to milliseconds
	client_clock += int(delta * 1000) + delta_latency
	delta_latency = 0
	# collects decimals left when delta is converted to an integer
	decimal_collector += (delta * 1000) - int(delta * 1000)
	if decimal_collector >= 1.00:
		client_clock += 1
		decimal_collector -= 1.00

func connect_to_server(ip, port):
	var network = NetworkedMultiplayerENet.new()
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")

func send_player_state(player_state):
	rpc_unreliable_id(1, "get_player_state", player_state)

remote func return_server_time(server_time, client_time):
	# calculate average latency between client and server
	latency = (OS.get_system_time_msecs() - client_time) / 2
	client_clock = server_time + latency

remote func return_latency(client_time):
	latency_array.append((OS.get_system_time_msecs() - client_time) / 2)
	if latency_array.size() == 9:
		# calculate average latency over past 4.5 secs,
		# then set latency to new average value
		var total_latency = 0
		latency_array.sort()
		var mid_point = latency_array[4]
		# iterate through array backwards
		for value in range(latency_array.size()-1,-1,-1):
			# remove value if it's extreme
			# the 'and' statement handles super fast connections
			if latency_array[value] > (2 * mid_point) and latency_array[value] > 20:
				latency_array.remove(value)
			else:
				total_latency += latency_array[value]
		# calculate difference in latency from the last time we calculated this
		delta_latency = (total_latency / latency_array.size()) - latency
		latency = total_latency / latency_array.size()
		print("New latency: ", latency)
		print("Delta latency: ", delta_latency)
		latency_array.clear()

remote func get_world_state(world_state):
	while not get_node("/root").has_node("GameController"):
		pass
	get_node("/root/GameController").update_world_state(world_state)

remote func get_game_info(map):
	# TODO: Why does this need to be in Global?
	Global.map = map
	get_tree().change_scene("res://GameController.tscn")
	rpc_id(1, "received_game_info")

remote func spawn_player(id, start_position):
	get_node("/root/GameController").spawn(id, start_position)

remote func despawn_player(id):
	get_node("/root/GameController").despawn(id)

remote func kicked(reason):
	Global.kick_reason = reason 
	get_parent().get_node("GameController").get_node(str(get_tree().get_network_unique_id())).get_node("Camera2D").make_current()
	get_tree().change_scene("res://MainMenu.tscn")
	get_tree().set_network_peer(null)

func _on_connection_succeeded():
	print("Successfully connected to server")
	rpc_id(1, "fetch_server_time", OS.get_system_time_msecs())
	$LatencyTimer.start()

func _on_LatencyTimer_timeout() -> void:
	rpc_id(1, "fetch_latency", OS.get_system_time_msecs())
