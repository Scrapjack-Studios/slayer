extends Node2D

var sprite_scale
var collision_scale_x
var collision_scale_y
var division_threshold

func _ready():
    $StaticBody2D.set_meta("level", 0)
    # warning-ignore:return_value_discarded
    $StaticBody2D.connect("body_entered", self, "subdivide", [$StaticBody2D])
    sprite_scale = $StaticBody2D/CollisionShape2D/Sprite.scale.x / 10
    collision_scale_x = $StaticBody2D/CollisionShape2D.scale.x / 2
    collision_scale_y = $StaticBody2D/CollisionShape2D.scale.y / 2
    division_threshold = $StaticBody2D/CollisionShape2D.scale.x / 2
    
func subdivide(body, node):
    if body.is_in_group("bullets") or Input.is_action_pressed("crouch"):
        node.queue_free()
        var division = node.get_meta("level")
        if division > division_threshold:
                node.queue_free()
                return
        var Stamp = node.duplicate()
        Stamp.set_meta("level", division + 1)
        
        
        Stamp.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
        var oldExtents = Stamp.get_node("CollisionShape2D").shape.extents
        var oldMass = Stamp.get_mass()
        Stamp.get_node("CollisionShape2D").shape.extents = Stamp.get_node("CollisionShape2D").shape.extents / 2
        
        var Clone = Stamp.duplicate()
        Clone.connect("body_entered", self, "subdivide", [Clone])
        Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
        Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,-oldExtents.y*collision_scale_y))
        Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
        Clone.set_mass(oldMass / 2)
        call_deferred("add_child", Clone)
            
        Clone = Stamp.duplicate()
        Clone.connect("body_entered", self, "subdivide", [Clone])
        Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
        Clone.set_position(Clone.get_position() + Vector2(oldExtents.x*collision_scale_x,-oldExtents.y*collision_scale_y))
        Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
        Clone.set_mass(oldMass / 2)
        call_deferred("add_child", Clone)
        
        Clone = Stamp.duplicate()
        Clone.connect("body_entered", self, "subdivide", [Clone])
        Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
        Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
        Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
        Clone.set_mass(oldMass / 2)
        call_deferred("add_child", Clone)
        
        Stamp.connect("body_entered", self, "subdivide", [Stamp])
        Stamp.set_position(Stamp.get_position() + Vector2(oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
        Stamp.get_node("CollisionShape2D").get_node("Sprite").scale = Stamp.get_node("CollisionShape2D").shape.extents * sprite_scale
        Stamp.set_mass(oldMass / 2)
        call_deferred("add_child", Stamp)
