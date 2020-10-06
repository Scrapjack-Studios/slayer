extends OptionButton


var weapon_number = 0

func _ready():
	for weapon in get_parent().get_node("Templates").get_children():
		add_item(weapon.name, weapon_number + 1)
	weapon_number =+ 1
