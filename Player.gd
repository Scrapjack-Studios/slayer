extends KinematicBody2D

signal health_changed(health)
signal died
signal respawn

enum MoveDirection { UP, DOWN, LEFT, RIGHT, NONE }

puppet var puppet_position = Vector2()
puppet var puppet_movement = MoveDirection.NONE
puppet var puppet_mouse_position = 0
puppet var puppet_weapon_position = Vector2()
puppet var puppet_weapon_flip = false

export (float) var max_health = 100
onready var health = max_health

export (PackedScene) var Bullet
export (int) var rot_speed
export (int) var damage
export (float) var bullet_lifetime
export (int, 0, 200) var push = 500

const FLOOR_ANGLE_TOLERANCE = 70 # Angle in degrees towards either side that the player can consider "floor"
const WALK_FORCE = 1600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 400
const STOP_FORCE = 1500
const JUMP_MAX_AIRBORNE_TIME = 0.4
const CLIMB_SPEED = 800
const CLIMB_AMOUNT = 70
const MAX_JUMP_COUNT = 2

var velocity = Vector2(0,0) # The velocity of the player (kept over time)
var chain_velocity := Vector2(0,0)
var gravity = 1500.0 # pixels/second/second
var rot_dir
var can_shoot = true
var can_move = true
var can_jump = true
var chain_pull = 55
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
var jump_strength = 750
var is_climbing = false
var can_walljump = true
var stopped_fire = false
var burst_loop = 0
var shots_fired_auto = 0
var shot = false
var stop
var force

func _ready():
    if Global.weapon1 == "shotgun":
        $Weapon/GunStats/Templates/shotgun.activate()
        $Weapon/GunStats.set_sprite()
    if Global.weapon1 == "assault_rifle":
        $Weapon/GunStats/Templates/assault_rifle.activate()
        $Weapon/GunStats.set_sprite()
    if Global.weapon1 == "pistol":
        $Weapon/GunStats/Templates/pistol.activate()
        $Weapon/GunStats.set_sprite()
    if Global.weapon1 == "m1":
        $Weapon/GunStats/Templates/m1.activate()
        $Weapon/GunStats.set_sprite()
    
func _input(event: InputEvent) -> void:
    
    if is_network_master():
        if event.is_action_pressed("Graphook") and can_grapple:
            rotation = 0
            $Chain.rpc("shoot", event.position - get_viewport().size * .57)
            is_grappling = true
            $Whip.hide()
        elif event.is_action_released("Graphook") and is_grappling:
            $Chain.rpc("release")
            $GrappleTimer.start()
            can_grapple = false
            is_grappling = false
            $Whip.show()
        
    if event.is_action_pressed("Weapon1"):
        if Global.weapon1 == "shotgun":
            $Weapon/GunStats/Templates/shotgun.activate()
            $Weapon/GunStats.set_sprite()
        if Global.weapon1 == "assault_rifle":
            $Weapon/GunStats/Templates/assault_rifle.activate()
            $Weapon/GunStats.set_sprite()
        if Global.weapon1 == "pistol":
            $Weapon/GunStats/Templates/pistol.activate()
            $Weapon/GunStats.set_sprite()
        if Global.weapon1 == "m1":
            $Weapon/GunStats/Templates/m1.activate()
            $Weapon/GunStats.set_sprite()
            
    if event.is_action_pressed("Weapon2"):
        if Global.weapon2 == "shotgun":
            $Weapon/GunStats/Templates/shotgun.activate()
            $Weapon/GunStats.set_sprite()
        if Global.weapon2 == "assault_rifle":
            $Weapon/GunStats/Templates/assault_rifle.activate()
            $Weapon/GunStats.set_sprite()
        if Global.weapon2 == "pistol":
            $Weapon/GunStats/Templates/pistol.activate()
            $Weapon/GunStats.set_sprite()
        if Global.weapon2 == "m1":
            $Weapon/GunStats/Templates/m1.activate()
            $Weapon/GunStats.set_sprite()
            
    if event.is_action_pressed("Weapon3"):
        if Global.weapon3 == "shotgun":
            $Weapon/GunStats/Templates/shotgun.activate()
            $Weapon/GunStats.set_sprite()
        if Global.weapon3 == "assault_rifle":
            $Weapon/GunStats/Templates/assault_rifle.activate()
            $Weapon/GunStats.set_sprite()
        if Global.weapon3 == "pistol":
            $Weapon/GunStats/Templates/pistol.activate()
            $Weapon/GunStats.set_sprite()
        if Global.weapon3 == "m1":
            $Weapon/GunStats/Templates/m1.activate()
            $Weapon/GunStats.set_sprite()
    
    if event.is_action_pressed("Weapon4"):
        if Global.weapon4 == "shotgun":
            $Weapon/GunStats/Templates/shotgun.activate()
            $Weapon/GunStats.set_sprite()
        if Global.weapon4 == "assault_rifle":
            $Weapon/GunStats/Templates/assault_rifle.activate()
            $Weapon/GunStats.set_sprite()
        if Global.weapon4 == "pistol":
            $Weapon/GunStats/Templates/pistol.activate()
            $Weapon/GunStats.set_sprite()
        if Global.weapon4 == "m1":
            $Weapon/GunStats/Templates/m1.activate()
            $Weapon/GunStats.set_sprite()
        
func _physics_process(delta):
    if get_tree().is_network_server():
        Network.update_position(int(name), position)
    
    var direction = MoveDirection.NONE
    on_air_time += delta
    
    if is_network_master():
        if Input.is_action_pressed('move_left'):
            direction = MoveDirection.LEFT
            is_walking = true
        elif Input.is_action_pressed('move_right'):
            direction = MoveDirection.RIGHT
            is_walking = true 
        
        if Input.is_action_just_pressed("jump") and can_jump:
            jump()
            if is_jumping or is_falling:
                if direction == MoveDirection.RIGHT and $Wall_Raycasts/Right/Wall_Detect_Right.is_colliding() and not $Wall_Raycasts/Right/Wall_Detect_Right3.is_colliding():
                    mantle("right")
                if direction == MoveDirection.LEFT and $Wall_Raycasts/Left/Wall_Detect_Left.is_colliding() and not $Wall_Raycasts/Left/Wall_Detect_Left3.is_colliding():
                    mantle("left")
                    
        if Input.is_action_just_pressed("tank_fire") and can_shoot:
            if $Weapon/GunStats.is_semi_auto:
                shoot("semi_auto")
            if $Weapon/GunStats.shotgun:
                shoot("shotgun")
            if $Weapon/GunStats.is_automatic:
                shoot("automatic")
        elif Input.is_action_just_released("tank_fire"):
            stopped_fire = true
        
        rset_unreliable('puppet_position', position)
        rset('puppet_movement', direction)
        move(direction)
    else:
        move(puppet_movement)
        position = puppet_position
    
    if is_on_floor():
        on_air_time = 0
        is_falling = false
        jump_count = 0
        has_pressed_jump = false
        is_climbing = false
        jump_strength = 750
        gravity = -1
    else:
        gravity = 1300
        
    if is_on_wall() and not is_climbing:
        _WallMount()
    else:
        can_walljump = true
        
    if is_jumping and velocity.y > 0:
        # If falling, no longer jumping
        is_jumping = false
        is_falling = true
        rotation = 0
            
    var mpos = get_global_mouse_position().angle_to_point(position)
    var weaponflip = $Weapon/Weapon_Sprite.flip_v
    var weaponpos = $Weapon.position
    
    if is_network_master():
        $Weapon.global_rotation = get_global_mouse_position().angle_to_point(position)
        if get_local_mouse_position().x < 0: # mouse is facing left
            $Weapon.set_position(Vector2(-22,10))
            $Weapon/Weapon_Sprite.set_flip_v(true)
        elif get_local_mouse_position().x > 0: # mouse is facing right
            $Weapon.set_position(Vector2(15,0))
            $Weapon/Weapon_Sprite.set_flip_v(false)
        rset("puppet_mouse_position", mpos)
        rset("puppet_weapon_position", weaponpos)
        rset("puppet_weapon_flip", weaponflip)
    else:
        $Weapon.global_rotation = puppet_mouse_position
        $Weapon.position = puppet_weapon_position
        $Weapon/Weapon_Sprite.flip_v = puppet_weapon_flip
        
    if $Chain.hooked:
        _ChainHook()
    else:
        # Not hooked -> no chain velocity
        chain_velocity = Vector2(0,0)
    velocity += chain_velocity

    if is_on_floor():
        rotation = get_floor_normal().angle() + PI/2
        
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
    velocity = move_and_slide(velocity, Vector2(0, -1), false, 4, PI/4, false)
    for index in get_slide_count():
        var collision = get_slide_collision(index)
        if collision.collider.is_in_group("bodies"):
                collision.collider.apply_central_impulse(-collision.normal * push)
       
func move(direction):
    force = Vector2(0, gravity) # create forces
    stop = true
    if can_move:
        if direction == MoveDirection.LEFT:
            if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
                force.x -= WALK_FORCE
                stop = false
        elif direction == MoveDirection.RIGHT:
            if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
                force.x += WALK_FORCE
                stop = false
        
func jump():
    if jump_count < MAX_JUMP_COUNT:
        velocity.y = -jump_strength
        jump_count += 1
        is_jumping = true
    # Jump must also be allowed to happen if the character left the floor a little bit ago. Makes controls more snappy.
    if on_air_time < JUMP_MAX_AIRBORNE_TIME and not prev_jump_pressed and not is_jumping:
        velocity.y = -jump_strength
        is_jumping = true
        rotation = 0
    prev_jump_pressed = Input.is_action_just_pressed("jump")          

func mantle(direction):
    if direction == "right":
        velocity.x = +CLIMB_AMOUNT
    elif direction == "left":
        velocity.x = -CLIMB_AMOUNT
    velocity.y = -CLIMB_SPEED
    is_climbing = true   
            
func shoot(weapon_type):
    if weapon_type == "semi_auto":
        can_shoot = false
        $Weapon/GunStats.rpc("_BulletPostition")
        var GunTimer = Timer.new()
        GunTimer.set_wait_time(get_node("Weapon/GunStats").cool_down)
        GunTimer.set_one_shot(true)
        self.add_child(GunTimer)
        GunTimer.start()
        yield(GunTimer, "timeout")
        GunTimer.queue_free()
        can_shoot = true
    if weapon_type == "shotgun":
        can_shoot = false
        $Weapon/GunStats.rpc("_BulletPostition")
        var GunTimer = Timer.new()
        GunTimer.set_wait_time(get_node("Weapon/GunStats").cool_down)
        GunTimer.set_one_shot(true)
        self.add_child(GunTimer)
        GunTimer.start()
        yield(GunTimer, "timeout")
        GunTimer.queue_free()
        can_shoot = true
    if weapon_type == "automatic":
        $Weapon/GunStats._BulletPostition()
        can_shoot = false
        var GunTimer = Timer.new()
        GunTimer.set_physics_process(true)
        GunTimer.set_wait_time(get_node("Weapon/GunStats").cool_down)
        GunTimer.set_one_shot(true)
        self.add_child(GunTimer)
        GunTimer.start()
        yield(GunTimer, "timeout")
        GunTimer.queue_free()
        can_shoot = true
        shots_fired_auto += 1
            
func _WallMount():
    velocity.y = lerp(velocity.y,0,0.3)
    jump_strength = 900
        
    if can_walljump:
        jump_count = 1
        can_walljump = false
    
    if not $Wall_Raycasts/Left/Wall_Detect_Left3:
        mantle("right")
            
    if not $Wall_Raycasts/Right/Wall_Detect_Right3:
        mantle("left")
                 
    if not is_on_wall() and not is_falling:
        jump_strength = 750
    if velocity.y > 0:
        rotation = 0
    
func Kickback(kickback):
    velocity = Vector2(kickback, 0).rotated($Weapon.global_rotation)
        
func take_damage(amount):
    health -= amount
    emit_signal("health_changed", (health * 100 / max_health))
    if health <= 0:
        rpc("die")
        
sync func die():
    emit_signal("died")
    hide()
    set_physics_process(false)
    can_shoot = false
    $Camera2D._set_current(false)
    call_deferred("set_disabled", true, $CollisionShape2D)
    
sync func respawn():
    show()
    set_physics_process(true)
    can_shoot = true
    call_deferred("set_disabled", false, $CollisionShape2D)
    health = max_health
    
    emit_signal("respawn")

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
    rotation = 0

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

func init(username, start_position):
    $Username.text = username
    global_position = start_position
