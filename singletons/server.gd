extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 4000

var players = { }
var start_position = Vector2(360,180)
var self_data = {name = '', position = Vector2(), received_disconnect=false}
var disconnected_player_info
var connected_player_info
var connected_player
var disconnected

signal player_disconnected
signal server_disconnected
signal player_connection_completed
signal player_disconnection_completed
signal server_stopped

func connect_to_server(ip, port):
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

	network.connect("connection_failed", self, "on_connection_failed")
	network.connect("connection_succeeded", self, "on_connection_succeeded")

func on_connection_failed():
	print("Failed to connect to server")

func on_connection_succeeded():
	print("Connected to server")
