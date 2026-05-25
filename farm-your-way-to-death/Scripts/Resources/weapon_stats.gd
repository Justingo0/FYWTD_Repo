extends Resource
class_name weapon_stats

@export var damage:int
@export var attack_speed:float #Player speed when used

var self_object:Node
var in_swing:bool = false

func use(player:CharacterBody2D):
	if in_swing: return
	
	var anim_player:AnimationPlayer = self_object.get_node("AnimationPlayer")
	var hitbox:CollisionShape2D = self_object.get_node("Hitbox")
	
	var original_speed = player.speed
	
	anim_player.play("attack", 0.3)
	
	in_swing = true
	player.speed = attack_speed
	
	await anim_player.animation_finished
	
	player.speed = original_speed
	hitbox.disabled = false
	in_swing = false
	print("Swing Ready")

func _init(vSelfObject:Node, vDamage:int=0, vAttackSpeed:float=0.1) -> void:
	self_object = vSelfObject
	damage = vDamage
	attack_speed = vAttackSpeed
