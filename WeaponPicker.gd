extends OptionButton


var weapon_number = 0


func _ready():
    var weapons = get_parent().get_node("Templates")
    for weapon in weapons.weapon_list:
        add_item(weapon.name, weapon_number + 1)
    weapon_number =+ 1
