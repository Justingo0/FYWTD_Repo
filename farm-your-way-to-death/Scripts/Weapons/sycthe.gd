extends Area2D

@onready var animator = $AnimationPlayer
@onready var cooldown_timer = $CooldownTimer
@onready var hitbox = $Hitbox

@onready var mainSprite = $Main
@onready var attackSprite = $Pivot

@onready var heldHandSprite = preload("res://Sprites/Player/Hand3.png")
@onready var inHandSprite = preload("res://Sprites/Player/Hand2.png")
@onready var normHandSprite = preload("res://Sprites/Player/Hand1.png")

@export var damage:int
@export var cooldown_time:float

var local_player

func _ready() -> void:
	mainSprite.visible = true
	attackSprite.visible = false
	
	cooldown_timer.wait_time = cooldown_time

func setHands(player:CharacterBody2D, leftSet:CompressedTexture2D, rightSet:CompressedTexture2D):
	var leftHand = player.get_node("LeftHand") as Sprite2D
	var rightHand = player.get_node("RightHand") as Sprite2D
	
	leftHand.texture = leftSet
	rightHand.texture = rightSet

func getHands(player:CharacterBody2D) -> Array[CompressedTexture2D]:
	var leftHand = player.get_node("LeftHand").texture
	var rightHand = player.get_node("RightHand").texture
	return [leftHand, rightHand]

func use(player:CharacterBody2D) -> void:
	if cooldown_timer.time_left != 0: return
	
	local_player = player
	
	var ogHand1 = getHands(player)[0]
	var ogHand2 = getHands(player)[1]
	
	animator.play("attack")
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.start()
	
	await animator.animation_finished
	
	setHands(player, ogHand1, ogHand2)

func trigger_hitbox() -> void:
	var attackingBodies = get_overlapping_bodies()
	
	for body in attackingBodies:
		if body.is_in_group("Enemy"):
			body.take_damage(damage)

func anim_half_way() -> void:
	setHands(local_player, heldHandSprite, normHandSprite)
