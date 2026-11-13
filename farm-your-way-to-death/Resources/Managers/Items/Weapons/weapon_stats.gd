## Stats for all weapons.
extends ItemStats
class_name WeaponStats

@export_group("Attack")
@export var damage:int
#Counts down during the weapon's attack animation
@export var cooldown:float
@export var knockback:float = 200
@export var special_cooldown:float

@export_group("Range")
@export var projectile:PackedScene
@export var projectile_speed:int
@export var max_ammo:int

#var missing_no = preload("res://Sprites/Objects/missing_texture.png")
#var empty_obj = preload("res://Scenes/Objects/Nodes/empty.tscn")

#func _init(vName:String="null", 
#vIcon:Texture2D=missing_no, 
#vItem_Scene_Path:String="res://Scenes/Objects/Nodes/empty.tscn",
#vDamage:int=0, 
#vCooldown:float=0.01, 
#vProjectile:PackedScene=empty_obj,
#vProjectile_Speed:int=0,
#vMax_Ammo:int=0) -> void:
	#name = vName
	#icon = vIcon
	#item_scene_path = vItem_Scene_Path
	#damage = vDamage
	#cooldown = vCooldown
	#projectile = vProjectile
	#projectile_speed = vProjectile_Speed
	#max_ammo = vMax_Ammo
