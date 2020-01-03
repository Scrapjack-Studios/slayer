extends RigidBody2D

#This function calls the hit_by_bullet method of the body it enters.
func _on_bullet_body_enter( body ):
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")

#This function plays the shutdown animation after timing out, which deletes the bullet.
func _on_Timer_timeout():
	$anim.play("shutdown")
