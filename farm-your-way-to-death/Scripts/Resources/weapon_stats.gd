## Base Variables and Functions for all weapons.
class_name WeaponStats
extends Resource

@export var name:String
## Inventory icon.
@export var icon:Texture2D

@export var damage:int
## Time it takes to use this weapon again. The timer starts as soon as the weapon is used.
@export var cooldown:float

func _init(vName:String="Null", vIcon:Texture2D=load("res://Sprites/Objects/missing_no.png"), vDamage:int=0, vCooldown:float=1) -> void:
	name = vName
	icon = vIcon
	damage = vDamage
	cooldown = vCooldown
