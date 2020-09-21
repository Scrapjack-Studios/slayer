extends StaticBody2D

export (int) var damage 

func _on_Area2D_body_entered(body):
    if body.is_in_group("Players"):
        body.take_damage(damage)
        body.rpc("spew_blood", body.global_position, body.global_rotation)
