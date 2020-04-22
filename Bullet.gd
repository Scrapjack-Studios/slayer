extends KinematicBody2D

var velocity = Vector2()
export (int) var speed
var damage


func _ready():
    set_process(true)
    
func start_at(pos, dir, type, dmg, lifetime):
    $Sprite.animation = type
    position = pos
    rotation = dir
    damage = dmg
    velocity = Vector2(speed, 0).rotated(dir)



func _physics_process(delta):
    var collision = move_and_collide(velocity * delta)
    if collision:
        velocity = velocity.bounce(collision.normal)
        if collision.collider.has_method("hit"):
            collision.collider.hit()

func _on_VisibilityNotifier2D_screen_exited():
    queue_free()
    
func explode():
    velocity = Vector2(0, 0)
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
