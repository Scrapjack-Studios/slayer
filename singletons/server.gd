extends Node

signal received_players_list

var players = {}
var old_players = {}
var self_data = {username = '', position = Vector2(), received_disconnect=false}
var start_position

func connect_to_server(ip, port, username):
	var network = NetworkedMultiplayerENet.new()
	self_data.username = username
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

# gets called by the server when a player connects, and then the player sends their info
remote func fetch_player_info():	
	rpc_id(1, "get_player_info", get_tree().get_network_unique_id(), self_data)

remote func get_map(map):
	# Why does this need to be in Global?
	Global.map = map
	get_tree().change_scene("res://GameController.tscn")

remote func get_players_list(updated_players_list):
	if players: # if players list isn't empty
		# store old player list
		old_players = players
	players = updated_players_list
	emit_signal("received_players_list")

remote func get_start_position(start_pos):
	start_position = start_pos

remote func kicked(reason):
	Global.kick_reason = reason 
	get_parent().get_node("GameController").get_node(str(get_tree().get_network_unique_id())).get_node("Camera2D").make_current()
	get_tree().change_scene("res://MainMenu.tscn")
	emit_signal("player_disconnection_completed", get_tree().get_network_unique_id())
	get_tree().set_network_peer(null)
