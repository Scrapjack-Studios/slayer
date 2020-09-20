extends StaticBody2D


func _on_Area2D_body_entered(body):
    if body.is_in_group("Players"):
        body.take_damage(10)
        body.rpc("spew_blood", body.global_position, body.global_rotation)
