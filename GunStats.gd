extends Node2D

export (PackedScene) var Bullet
export (int) var dmg

export (bool) var is_automatic
export (bool) var is_burst
export (bool) var is_semi_auto
#only of these can be set to true


export (bool) var shotgun
#does nothing at the moment

export (float) var cool_down
#cool_down time for each shot, could also be reload time and effects the time in betwene shots of auto fire

export (int) var burst_ammount
#how many bullets are shot in one burst

export (Vector2) var bullet_size
#default is 0.2



export (bool) var assalt_sound
export (bool) var combat_shotgun_sound
export (bool) var super_shotgun_sound
export (bool) var pistol_sound
