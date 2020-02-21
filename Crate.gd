extends Area2D

func _ready():
	pass

func _on_Crate_body_entered( body ):
	if body.get_name() == "Tank":
		print("got it!")
		queue_free()
