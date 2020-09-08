extends Node2D

var sprite_scale
var collision_scale_x
var collision_scale_y
var division_threshold
var can_break = true
var division_number = 1
var has_fallen = true
func _ready():
    $StaticBody2D.set_meta("level", 0)
    # warning-ignore:return_value_discarded
    $StaticBody2D.connect("body_entered", self, "subdivide", [$StaticBody2D])
    sprite_scale = $StaticBody2D/CollisionShape2D/Sprite.scale.x / 10
    collision_scale_x = $StaticBody2D/CollisionShape2D.scale.x / 2
    collision_scale_y = $StaticBody2D/CollisionShape2D.scale.y / 2
    division_threshold = $StaticBody2D/CollisionShape2D.scale.x / 2
    
func subdivide(body, node):
    if not has_fallen:
        $Fall.play()
        has_fallen = true
    if body.is_in_group("bullets") and can_break:
        $Break.play()
        can_break = false
        node.queue_free()
        division_number = (division_number + 1)
        var division = node.get_meta("level")
        if division > division_threshold:
                node.queue_free()
                return
        var Stamp = node.duplicate()
        Stamp.set_meta("level", division + 1)
        
        
        Stamp.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
#        $Break.play()
        var oldExtents = Stamp.get_node("CollisionShape2D").shape.extents
        var oldMass = Stamp.get_mass()
        var oldGravity = Stamp.get_gravity_scale()
        
        Stamp.get_node("CollisionShape2D").shape.extents = Stamp.get_node("CollisionShape2D").shape.extents / 2
        
        var Clone = Stamp.duplicate()
        Clone.connect("body_entered", self, "subdivide", [Clone])
        Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
        Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,-oldExtents.y*collision_scale_y))
        Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
        Clone.set_mass(oldMass / 2)
        Clone.set_gravity_scale(oldGravity / 2)
        call_deferred("add_child", Clone)
       
        
        Clone = Stamp.duplicate()
        Clone.connect("body_entered", self, "subdivide", [Clone])
        Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
        Clone.set_position(Clone.get_position() + Vector2(oldExtents.x*collision_scale_x,-oldExtents.y*collision_scale_y))
        Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
        Clone.set_mass(oldMass / 2)
        Clone.set_gravity_scale(oldGravity / 2)
        call_deferred("add_child", Clone)
        
        
        Clone = Stamp.duplicate()
        Clone.connect("body_entered", self, "subdivide", [Clone])
        Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
        Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
        Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
        Clone.set_mass(oldMass / 2)
        Clone.set_gravity_scale(oldGravity / 2)
        call_deferred("add_child", Clone)
        
        
        Stamp.connect("body_entered", self, "subdivide", [Stamp])
        Stamp.set_position(Stamp.get_position() + Vector2(oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
        Stamp.get_node("CollisionShape2D").get_node("Sprite").scale = Stamp.get_node("CollisionShape2D").shape.extents * sprite_scale
        Stamp.set_mass(oldMass / 2)
        Clone.set_gravity_scale(oldGravity / 2)
        call_deferred("add_child", Stamp)
        
        
        if division_number == 2:
            Stamp.get_node("CollisionShape2D").get_node("Particles2D").get_process_material().set_emission_sphere_radius(40)
            Stamp.get_node("CollisionShape2D").get_node("Particles2D").set_amount(25)
        if division_number == 3:
            Stamp.get_node("CollisionShape2D").get_node("Particles2D").get_process_material().set_emission_sphere_radius(20)
            Stamp.get_node("CollisionShape2D").get_node("Particles2D").set_amount(17)
        if division_number == 4:
            Stamp.get_node("CollisionShape2D").get_node("Particles2D").get_process_material().set_emission_sphere_radius(10)
            Stamp.get_node("CollisionShape2D").get_node("Particles2D").set_amount(8)
        if division_number == 5:
            Stamp.get_node("CollisionShape2D").get_node("Particles2D").get_process_material().set_emission_sphere_radius(5)
            Stamp.get_node("CollisionShape2D").get_node("Particles2D").set_amount(8)
        if division_number == 6:
            Stamp.get_node("CollisionShape2D").get_node("Particles2D").get_process_material().set_emission_sphere_radius(3)
            Stamp.get_node("CollisionShape2D").get_node("Particles2D").set_amount(4)
            
        Stamp.get_node("CollisionShape2D").get_node("Particles2D").set_emitting(true)
        var RTimer = Timer.new()
        RTimer.set_wait_time(0.2)
        RTimer.set_one_shot(true)
        self.add_child(RTimer)
        RTimer.start()
        yield(RTimer, "timeout")
        RTimer.queue_free()
        Stamp.get_node("CollisionShape2D").get_node("Particles2D").set_emitting(false)
        can_break = true
