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
	collision_scale_x = $StaticBody2D/CollisionShape2D.scale.x / 3
	collision_scale_y = $StaticBody2D/CollisionShape2D.scale.y / 3
	division_threshold = $StaticBody2D/CollisionShape2D.scale.x / 3
	
func _physics_process(_delta):
	if not can_break:
		var GunTimer = Timer.new()
		GunTimer.set_physics_process(false)
		GunTimer.set_wait_time(0.005)
		GunTimer.set_one_shot(true)
		self.add_child(GunTimer)
		GunTimer.start()
		yield(GunTimer, "timeout")
		can_break = true
		GunTimer.queue_free()
	
func subdivide(body, node):
	if body.is_in_group("bullets") and can_break:
		$Break.play()
		node.queue_free()
		division_number = (division_number + 1)
		can_break = false
		var division = node.get_meta("level")
		if division > division_threshold:
				node.queue_free()
				return
		var Stamp = node.duplicate()
		Stamp.set_meta("level", division + 1)
		
		
		Stamp.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
		var oldExtents = Stamp.get_node("CollisionShape2D").shape.extents
		var oldMass = Stamp.get_mass()
		var oldGravity = Stamp.get_gravity_scale()
		
	 
		Stamp.get_node("CollisionShape2D").shape.extents = Stamp.get_node("CollisionShape2D").shape.extents / 3
		
		var Clone = Stamp.duplicate()
		Clone.connect("body_entered", self, "subdivide", [Clone])
		Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
		Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,-oldExtents.y*collision_scale_y))
		Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
		Clone.set_mass(oldMass / 3)
		Clone.set_gravity_scale(oldGravity / 3)
		call_deferred("add_child", Clone)
	   
		
		Clone = Stamp.duplicate()
		Clone.connect("body_entered", self, "subdivide", [Clone])
		Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
		Clone.set_position(Clone.get_position() + Vector2(oldExtents.x*collision_scale_x,-oldExtents.y*collision_scale_y))
		Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
		Clone.set_mass(oldMass / 3)
		Clone.set_gravity_scale(oldGravity / 3)
		call_deferred("add_child", Clone)
		
		
		Clone = Stamp.duplicate()
		Clone.connect("body_entered", self, "subdivide", [Clone])
		Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
		Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
		Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
		Clone.set_mass(oldMass / 3)
		Clone.set_gravity_scale(oldGravity / 3)
		call_deferred("add_child", Clone)
		
		Clone = Stamp.duplicate()
		Clone.connect("body_entered", self, "subdivide", [Clone])
		Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
		Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
		Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
		Clone.set_mass(oldMass / 3)
		Clone.set_gravity_scale(oldGravity / 3)
		call_deferred("add_child", Clone)
		
		Clone = Stamp.duplicate()
		Clone.connect("body_entered", self, "subdivide", [Clone])
		Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
		Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
		Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
		Clone.set_mass(oldMass / 3)
		Clone.set_gravity_scale(oldGravity / 3)
		call_deferred("add_child", Clone)
		
		Clone = Stamp.duplicate()
		Clone.connect("body_entered", self, "subdivide", [Clone])
		Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
		Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
		Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
		Clone.set_mass(oldMass / 3)
		Clone.set_gravity_scale(oldGravity / 3)
		call_deferred("add_child", Clone)
		
		Clone = Stamp.duplicate()
		Clone.connect("body_entered", self, "subdivide", [Clone])
		Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
		Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
		Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
		Clone.set_mass(oldMass / 3)
		Clone.set_gravity_scale(oldGravity / 3)
		call_deferred("add_child", Clone)
		
		Clone = Stamp.duplicate()
		Clone.connect("body_entered", self, "subdivide", [Clone])
		Clone.get_node("CollisionShape2D").shape = Stamp.get_node("CollisionShape2D").shape.duplicate(true)
		Clone.set_position(Clone.get_position() + Vector2(-oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
		Clone.get_node("CollisionShape2D").get_node("Sprite").scale = Clone.get_node("CollisionShape2D").shape.extents * sprite_scale
		Clone.set_mass(oldMass / 3)
		Clone.set_gravity_scale(oldGravity / 3)
		call_deferred("add_child", Clone)
		
		
		Stamp.connect("body_entered", self, "subdivide", [Stamp])
		Stamp.set_position(Stamp.get_position() + Vector2(oldExtents.x*collision_scale_x,oldExtents.y*collision_scale_y))
		Stamp.get_node("CollisionShape2D").get_node("Sprite").scale = Stamp.get_node("CollisionShape2D").shape.extents * sprite_scale
		Stamp.set_mass(oldMass / 3)
		Clone.set_gravity_scale(oldGravity / 3)
		call_deferred("add_child", Stamp)
		
		
