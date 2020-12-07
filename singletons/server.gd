extends Node

func connect_to_server(ip, port):
	var network = NetworkedMultiplayerENet.new()
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

func send_player_state(player_state):
	rpc_unreliable_id(1, "get_player_state", player_state)

remote func get_game_info(map):
	# Why does this need to be in Global?
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
