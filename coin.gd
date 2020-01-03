extends Area2D

#Initializing Variables
var taken=false

#This function detects the body entering the coin.
#If this body is the player, the coin plays the "taken" animation, deleting itself.
func _on_coin_body_enter( body ):
	if not taken and body is preload("res://player.gd"):
		$anim.play("taken")
		taken = true
