extends Camera2D

# Radius of the zone in the middle of the screen where the cam doesn't move
const DEAD_ZONE = 160

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion: # If the mouse moved...
        var _target = event.position - get_viewport().size * 2	# Get the mouse position relative to the middle of the screen
        if _target.length() < DEAD_ZONE:	# If we're in the middle (dead zone)...
            self.position = Vector2(0,0)	# ... reset the camera to the middle (= center on player)
        else:
            # _target.normalized() is the direction in which to move
            # _target.length() - DEAD_ZONE is the distance the mouse is outside of the dead zone
            # 0.5 is an arbitrary scalar
            self.position = _target.normalized() * (_target.length() - DEAD_ZONE) * .2
