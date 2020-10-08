extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 4000

func _ready() -> void:
	connect_to_server()

func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

	network.connect("connection_failed", self, "on_connection_failed")
	network.connect("connection_succeeded", self, "on_connection_succeeded")

func on_connection_failed():
	print("Failed to connect to server")

func on_connection_succeeded():
	print("Connected to server")
