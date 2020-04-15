extends Area2D

var size = 32 
export(int) var min_size = 4

func _ready():
# warning-ignore:return_value_discarded
    connect("area_entered", self, "_on_blockx32_area_enter")
    
    
func _on_blockx32_area_enter(_a):
    if size <= min_size:
        queue_free()
        call_deferred("area_set_shape_disabled")
        return
    for i in range (0,2):
        var newNode = duplicate()
        newNode.size = size/2
        get_parent().call_deferred("add_child", newNode)
        newNode.set_scale(get_scale()/2)
        newNode.set_position(Vector2(get_position().x - size/4 + (size/2 * i), get_position().y - size/4))
    for i in range (0,2):
        var newNode = duplicate()
        newNode.size = size/2
        get_parent().call_deferred("add_child", newNode)
        newNode.set_scale(get_scale()/2)
        newNode.set_position(Vector2(get_position().x - size/4 + (size/2 * i), get_position().y + size/4))
    queue_free()

