extends Node

const DEFAULT_IP = '192.168.50.10'
const DEFAULT_PORT = 31400
const MAX_PLAYERS = 5

var players = { }
var start_position = Vector2(360,180)
var self_data = {name = '', position = Vector2()}
var disconnected_player_info
var connected_player_info
var connected_player

# warning_ignore:unused_signal
signal player_disconnected
# warning_ignore:unused_signal
signal server_disconnected
signal player_connection_completed

func _ready():
    # warning-ignore:return_value_discarded
    get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
    # warning-ignore:return_value_discarded
    get_tree().connect('network_peer_connected', self, '_on_player_connected')

func create_server(port, player_nickname):
    self_data.name = player_nickname
    players[1] = self_data
    var peer = NetworkedMultiplayerENet.new()
    peer.create_server(port, MAX_PLAYERS)
    get_tree().set_network_peer(peer)

func connect_to_server(ip, port, player_nickname):
    self_data.name = player_nickname
    # warning-ignore:return_value_discarded
    get_tree().connect('connected_to_server', self, '_connected_to_server')
    var peer = NetworkedMultiplayerENet.new()
    peer.create_client(ip, port)
    get_tree().set_network_peer(peer)
    
func close_server():
    #kick players
    for player in players:
        if player != 1:
            kick_player(player, "Server Closed")
    # terminate server
    get_tree().set_network_peer(null)
#    emit_signal("server_stopped")
    
func kick_player(player, reason):
    $"/root/GameController".get_node(str(player)).rpc("kicked", reason)
    get_tree().network_peer.disconnect_peer(player)
    
func update_position(id, position):
    players[id].position = position
    
func _connected_to_server():
    var local_player_id = get_tree().get_network_unique_id()
    players[local_player_id] = self_data
    rpc('_send_player_info', local_player_id, self_data)

func _on_player_disconnected(id):
    disconnected_player_info = players[id]
    players.erase(id)

func _on_player_connected(connected_player_id):
    connected_player = connected_player_id
    var local_player_id = get_tree().get_network_unique_id()
    if not(get_tree().is_network_server()):
        rpc_id(1, '_request_player_info', local_player_id, connected_player_id)
        rpc_id(1, '_request_map', local_player_id)

remote func _request_player_info(request_from_id, player_id):
    if get_tree().is_network_server():
        rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])

remote func _request_players(request_from_id):
    if get_tree().is_network_server():
        for peer_id in players:
            if( peer_id != request_from_id):
                rpc_id(request_from_id, '_send_player_info', peer_id, players[peer_id])
    
remote func _request_map(request_from_id):
    if get_tree().is_network_server():
        rpc_id(request_from_id, '_send_map', Global.map)
        
remote func _send_map(map):
    Global.map = map

remote func _send_player_info(id, info):
    players[id] = info
    var new_player = load('res://Player.tscn').instance()
    new_player.name = str(id)
    new_player.set_network_master(id)
    $'/root/GameController'.add_child(new_player)
    new_player.init(info.name, info.position)
    if connected_player in players:
        connected_player_info = players[connected_player]
        emit_signal("player_connection_completed")
