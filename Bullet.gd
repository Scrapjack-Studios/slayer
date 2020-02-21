extends RigidBody2D

export (int) var speed

var damage

func start_at(pos, dir, type, dmg, lifetime):
	$Sprite.animation = type
	position = pos
	rotation = dir
	damage = dmg
	$Lifetime.wait_time = lifetime
	linear_velocity = Vector2(speed, 0).rotated(dir)

func explode():
	linear_velocity = Vector2(0, 0)
	$Sprite.hide()
	$Explosion.show()
	$Explosion.play("smoke")
	
func _on_Lifetime_timeout():
	explode()

func _on_Bullet_body_entered( body ):
	explode()
	if body.has_method("take_damage"):
		body.take_damage(damage)
	#call_deferred("set_contact_monitor",false)

func _on_Explosion_animation_finished():
	queue_free()
