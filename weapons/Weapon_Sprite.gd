extends Sprite


func _ready():
    texture = get_parent().get_node("GunStats").weapon_sprite
    set_scale(get_parent().get_node("GunStats").weapon_size)
    position = get_parent().get_node("GunStats").weapon_position
