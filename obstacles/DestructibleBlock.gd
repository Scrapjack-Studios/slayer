extends Node2D

var sprite_scale
var collision_scale_x
var collision_scale_y
var division_threshold

func _ready():
    $StaticBody2D.set_meta("level", 0)
    # warning-ignore:return_value_discarded
    $StaticBody2D.connect("body_entered", self, "subdivide", [$StaticBody2D], CONNECT_ONESHOT)
    sprite_scale = $StaticBody2D/CollisionShape2D/Sprite.scale.x / 10
    collision_scale_x = $StaticBody2D/CollisionShape2D.scale.x / 2
    collision_scale_y = $StaticBody2D/CollisionShape2D.scale.y / 2
    division_threshold = $StaticBody2D/CollisionShape2D.scale.x / 4
        
func subdivide(body, node):
    if body.collision_layer == 2:
        node.queue_free()
        var division = node.get_meta("level")
        if division > division_threshold:
                node.queue_free()
                return
        var Stamp = node.duplicate()
        Stamp.set_meta("level", division + 1)
        
        Stamp.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
        var oldExtents = Stamp.get_node("CollisionShape2D").shape.extents
        Stamp.get_node("CollisionShape2D").shape.extents = Stamp.get_node("CollisionShape2D").shape.extents / 2
        
        var Clone = Stamp.duplicate()
        Clone.connect("body_entered", self, "subdivide", [Clone], CONNECT_ONESHOT)
        Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
        Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,-oldExtents.y*collision_scale_y))
        Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
    #    add_child(Clone)
        call_deferred("add_child", Clone)
            
        Clone = Stamp.duplicate()
        Clone.connect("body_entered", self, "subdivide", [Clone], CONNECT_ONESHOT)
        Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
        Clone.set_position(Clone.get_position() + Vector2(oldExtents.x*collision_scale_x,-oldExtents.y*collision_scale_y))
        Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
        call_deferred("add_child", Clone)
        
        Clone = Stamp.duplicate()
        Clone.connect("body_entered", self, "subdivide", [Clone], CONNECT_ONESHOT)
        Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
        Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
        Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
        call_deferred("add_child", Clone)
        
        Stamp.connect("body_entered", self, "subdivide", [Stamp], CONNECT_ONESHOT)
        Stamp.set_position(Stamp.get_position() + Vector2(oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
        Stamp.get_node("CollisionShape2D").get_node("Sprite").scale = Stamp.get_node("CollisionShape2D").shape.extents * sprite_scale
        call_deferred("add_child", Stamp)


func _on_StaticBody2D_body_entered(body):
    if body.collision_layer == 2:
        print("yay")
