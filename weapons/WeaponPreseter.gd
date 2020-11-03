extends Node

class_name weapon_setter

export (bool) var semi_auto
export (bool) var automatic
export (bool) var burst_fire
export (bool) var shotgun
export (float) var cool_down
export (int) var mag
export (int) var shots_fired
export (int) var reload
export (Texture) var weapon_sprite 
export (int) var kickback
export (int) var burst_ammount
export (float) var dmg
export (int) var shotgun_pellets
export (int) var area_effect
export(int, "Pistol", "Assault", "Shotgun", "Carbine") var Weapon_Sounds
var GunStatsRef = get_parent().get_parent().get_parent().get_node("GunStats")


func activate():
	GunStatsRef.get_node("Sounds/FireSound").shotgun = Weapon_Sounds == 2
	GunStatsRef.get_node("Sounds/FireSound").pistol = Weapon_Sounds == 0
	GunStatsRef.get_node("Sounds/FireSound").assault = Weapon_Sounds == 1
	GunStatsRef.dmg = dmg
	GunStatsRef.is_semi_auto = semi_auto
	GunStatsRef.is_automatic = automatic
	GunStatsRef.is_burst_fire = burst_fire
	GunStatsRef.shotgun = shotgun
	GunStatsRef.burst_ammount = burst_ammount
	GunStatsRef.shotgun_pellets = shotgun_pellets
	GunStatsRef.cool_down = cool_down
	GunStatsRef.weapon_sprite = weapon_sprite
	GunStatsRef.mag = mag
	GunStatsRef.shots_fired = shots_fired
	GunStatsRef.kickback = kickback
	GunStatsRef.area_effect = area_effect


