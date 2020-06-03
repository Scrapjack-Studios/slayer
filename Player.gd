extends KinematicBody2D

signal health_changed
signal died

export (PackedScene) var Bullet
export (int) var rot_speed
export (int) var damage
export (int) var start_health
export (float) var bullet_lifetime
# Member variables
# Member variables
var gravity = 1300.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 70
const WALK_FORCE = 1600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 400
const STOP_FORCE = 1500
const JUMP_MAX_AIRBORNE_TIME = 0.4
const CLIMB_SPEED = 600
const CLIMB_AMOUNT = 70
const MAX_JUMP_COUNT = 2

var velocity = Vector2(0,0)		# The velocity of the player (kept over time)
var chain_velocity := Vector2(0,0)
var rot_dir
var can_shoot = true
var health
var chain_pull = 50
var on_air_time = 100
var is_jumping = false
var can_doublejump = true
var is_falling = false
var grabbing
var prev_jump_pressed = false
var is_walking = false
var can_grapple = true
var is_grappling = false
var jump_count = 0
var is_wall_sliding = false
var has_pressed_jump
var jump_strength = 600
var is_climbing = false
var can_walljump = true

func _ready():
    health = start_health
    emit_signal("health_changed", health)
    
func _input(event: InputEvent) -> void:
    
    if event.is_action_pressed("tank_fire") and can_shoot:
        can_shoot = false
        $GunTimer.start()
        var b = Bullet.instance()
        b.start_at($"Turret/Muzzle".global_position, $Turret.global_rotation,'blue', damage, bullet_lifetime)
        $Bullets.add_child(b)
    
    if event.is_action_pressed("Graphook") and can_grapple:
        # We clicked the mouse -> shoot()
        $Chain.shoot(event.position - get_viewport().size * .54)
        is_grappling = true
        $Whip.hide()

        
    elif event.is_action_released("Graphook") and is_grappling:
        $Chain.release()
        $GrappleTimer.start()
        can_grapple = false
        is_grappling = false
        $Whip.show()
    
    if event.is_action_pressed("jump"):
        is_jumping = false
    if jump_count < MAX_JUMP_COUNT and event.is_action_pressed("jump"):
        velocity.y = -jump_strength
        jump_count += 1
        
func _physics_process(delta):
    var mpos = get_global_mouse_position()
    
    $Turret.global_rotation = mpos.angle_to_point(position)  
       
    var force = Vector2(0, gravity) # create forces 
    
    var move_left = Input.is_action_pressed("move_left")
    
    var move_right = Input.is_action_pressed("move_right")
    
    var jump = Input.is_action_pressed("jump")
    
    if move_left or move_right:
        is_walking = true
    
    var stop = true
    
    if get_local_mouse_position().x < 0: # mouse is facing left
        $Turret.set_position(Vector2(-22,0))
        
    elif get_local_mouse_position().x > 0: # mouse is facing right
        $Turret.set_position(Vector2(15,0))
 
    if $Chain.hooked:
        _ChainHook()

    
    else:
        # Not hooked -> no chain velocity
        chain_velocity = Vector2(0,0)
        
    velocity += chain_velocity

    if move_left:
        if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
            force.x -= WALK_FORCE
            stop = false
    elif move_right:
        if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
            force.x += WALK_FORCE
            stop = false
        
    if stop:
        var vsign = sign(velocity.x)
        var vlen = abs(velocity.x)
        
        vlen -= STOP_FORCE * delta
        if vlen < 0:
            vlen = 0
        
        velocity.x = vlen * vsign
    
    # Integrate forces to velocity
    velocity += force * delta    
    # Integrate velocity into motion and move
    velocity = move_and_slide(velocity, Vector2(0, -1))
    
    if is_on_floor():
        on_air_time = 0
        is_falling = false
        jump_count = 0
        has_pressed_jump = false
        is_climbing = false
        jump_strength = 600
        gravity = -1
    else:
        gravity = 1300
        
    if is_jumping and velocity.y > 0:
        # If falling, no longer jumping
        is_jumping = false
        is_falling = true
        
    if [is_jumping or is_falling] and move_right and $Wall_Raycasts/Right/Wall_Detect_Right.is_colliding() and not $Wall_Raycasts/Right/Wall_Detect_Right3.is_colliding():
        _MantelRight()

    if [is_jumping or is_falling] and move_left and $Wall_Raycasts/Left/Wall_Detect_Left.is_colliding() and not $Wall_Raycasts/Left/Wall_Detect_Left3.is_colliding():
        _MantelLeft()

        
    if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not is_jumping:
        # Jump must also be allowed to happen if the character left the floor a little bit ago.
        # Makes controls more snappy.
        velocity.y = -jump_strength
        is_jumping = true
    
    on_air_time += delta
    
    prev_jump_pressed = jump
    
    if is_on_wall() and not is_climbing:
        _WallMount()
    else:
        can_walljump = true
    
    if $Wall_Raycasts/Upper_Detect.is_colliding() or $Wall_Raycasts/Upper_Detect_Left.is_colliding() or $Wall_Raycasts/Upper_Detect_Right.is_colliding():
        _HeadBump()
        
func _WallMount():
    velocity.y = lerp(velocity.y,0,0.3)
    jump_strength = 800
        
    if can_walljump:
        jump_count = 1
        can_walljump = false
    
            
    if not $Wall_Raycasts/Left/Wall_Detect_Left3:
        _MantelLeft()
            
    if not $Wall_Raycasts/Right/Wall_Detect_Right3:
        _MantelRight()
                 
    if not is_on_wall() and not is_falling:
        jump_strength = 600
        
func _MantelRight():
    velocity.x = +CLIMB_AMOUNT
    velocity.y = -CLIMB_SPEED
    is_climbing = true
    
func _MantelLeft():       
    velocity.x = -CLIMB_AMOUNT
    velocity.y = -CLIMB_SPEED
    is_climbing = true   
        
func _on_GunTimer_timeout():
    can_shoot = true
    
func take_damage(amount):
    health -= amount
    emit_signal("health_changed", (health * 100 / start_health))
    if health <= 0:
        emit_signal("died")
        print("Dead!")

func _on_GrappleTimer_timeout():
    $GrappleTimer.stop()
    can_grapple = true

func _on_WallJumpTimer_timeout():
    can_doublejump = true


func _ChainHook():
    chain_velocity = to_local($Chain.tip).normalized() * chain_pull
    if chain_velocity.y > 0:
        # Pulling down isn't as strong
        chain_velocity.y *= 1.65
    else:
        # Pulling up is stronger
        chain_velocity.y *= 1.65


func _HeadBump():
    $Blur.show()
    OS.delay_msec(15)
    var t = Timer.new()
    t.set_wait_time(0.3)
    t.set_one_shot(true)
    self.add_child(t)
    t.start()
    yield(t, "timeout")
    $Blur.hide()
    t.queue_free()
