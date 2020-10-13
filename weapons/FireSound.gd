extends AudioStreamPlayer2D

var assault
var shotgun
var pistol

func activate():
	if assault:
		stream = load("res://assets/sfx/weapons/AssaultRifle.wav")
	if pistol:
		stream = load("res://assets/sfx/weapons/Pistol.wav")
	if shotgun:
		stream = load("res://assets/sfx/weapons/Combat_Shotgun.wav")
