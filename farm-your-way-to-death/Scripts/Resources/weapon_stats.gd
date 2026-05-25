extends Resource
class_name weapon_stats

@export var damage:int
@export var cooldown:float

var self_object:Node
var in_swing:bool = false

func use():
	if in_swing: return
	
	var anim_player:AnimationPlayer = self_object.get_node("AnimationPlayer")
	anim_player.play("attack", 0.3)
	in_swing = true
	await anim_player.animation_finished
	in_swing = false
	print("Swing Ready")

func _init(vSelfObject:Node, vDamage:int=0, vCooldown:float=0.1) -> void:
	self_object = vSelfObject
	damage = vDamage
	cooldown = vCooldown
