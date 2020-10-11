extends Node

var network = NetworkedMultiplayerENet.new()
var players = {}
var self_data = {username = '', position = Vector2(), received_disconnect=false}

func connect_to_server(ip, port, username):
	self_data.username = username
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

# gets called by the server when a player connects, and then the player sends their info
remote func fetch_player_info():
	rpc_id(1, "get_player_info", get_tree().get_network_unique_id(), self_data)

remote func get_map(map):
	Global.map = map
	get_tree().change_scene("res://GameController.tscn")

remote func get_players_list(players_list):
	players = players_list

remote func kicked(reason):
	Global.kick_reason = reason 
	get_parent().get_node("GameController").get_node(str(get_tree().get_network_unique_id())).get_node("Camera2D").make_current()
	get_tree().change_scene("res://MainMenu.tscn")
	emit_signal("player_disconnection_completed", get_tree().get_network_unique_id())
	get_tree().set_network_peer(null)

#remote func receive_players_info(id, info):
#	players[id] = info
#	if connected_player in players:
#		connected_player_info = players[connected_player]
#		emit_signal("player_connection_completed")
#	print(players)

#remote func _request_players(request_from_id):
#	if get_tree().is_network_server():
#		rpc_id(request_from_id, '_send_players', players)
#
#remote func _send_players(players_array):
#	players = players_array
