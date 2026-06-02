extends CharacterBody2D

@onready var item_slot := $ItemSlot
@onready var left_slot := $LeftSlot
@onready var right_slot := $RightSlot

@onready var lHand = $LeftHand
@onready var rHand = $RightHand
@onready var anim = $Animation
@onready var anim_player = $AnimationPlayer

@onready var hand1 = preload("res://Sprites/Player/Hand1.png")
@onready var hand2 = preload("res://Sprites/Player/Hand2.png")
@onready var hand3 = preload("res://Sprites/Player/Hand3.png")

@export var speed:int = 70
@export var acceleration:int = 60

@export var max_health:int = 100
@export var health:int = 100
@export var max_hunger:int = 100
@export var hunger:int = 100

var tween_life:float = 0.5
var last_dir:String = "Left"

var held_item = null
@export var closest_item = null

func _ready() -> void:
	add_to_group("Player")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action("Test"):
			health -= 1
		if event.is_action("Test2"):
			health += 1
		if event.is_action_pressed("Interact"):
			var newItem = closest_item.item.instantiate()
			if not newItem.is_in_group("Weapon"):
				right_slot.add_child(newItem)
				rHand.texture = hand3
			else:
				item_slot.add_child(newItem)
			held_item = newItem
			closest_item.queue_free()

func _physics_process(delta: float) -> void:
	var input_axis:Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	var target_accel = acceleration*100
	var target_speed = speed*10
	var target_velocity:Vector2 = input_axis * target_speed
	velocity = Vector2(move_toward(velocity.x, target_velocity.x, target_accel * delta), move_toward(velocity.y, target_velocity.y, target_accel * delta))
	
	if Input.is_action_pressed("Attack"):
		if held_item:
			held_item.use(self)
	
	if input_axis.x > 0:
		anim.play("run")
		anim_player.play("runRight", tween_life)
		anim.flip_h = true
		
		last_dir = "Right"
	elif input_axis.x < 0:
		anim.play("run")
		anim_player.play("runLeft", tween_life)
		anim.flip_h = false
		
		last_dir = "Left"
	elif input_axis.y > 0:
		anim.play("run")
		if last_dir == "Left":
			anim_player.play("runLeft", tween_life)
		else:
			anim_player.play("runRight", tween_life)
	elif input_axis.y < 0:
		anim.play("run")
		if last_dir == "Left":
			anim_player.play("runRight", tween_life)
		else:
			anim_player.play("runLeft", tween_life)
	else:
		anim_player.play("idle", tween_life)
		anim.play("idle")
	
	health = clamp(health, 0, max_health)
	
	move_and_slide()

func take_damage(damageDealt:int):
	health -= damageDealt
