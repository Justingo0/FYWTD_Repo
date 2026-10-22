extends CharacterBody2D

signal on_item_collected(id:int, item_class:ItemStats)
signal on_item_equipped(id:int, is_new:bool)

signal on_health_changed(value:int, max_value:int)

signal on_enemy_killed()

@onready var item_slot := $ItemSlot
@onready var left_slot := $LeftSlot
@onready var right_slot := $RightSlot

@onready var lHand = $LeftHand
@onready var rHand = $RightHand
@onready var anim = $Animation
@onready var anim_player = $AnimationPlayer

@onready var hand1 = preload("res://Assets/Player/Hand1.png")
@onready var hand2 = preload("res://Assets/Player/Hand2.png")
@onready var hand3 = preload("res://Assets/Player/Hand3.png")

@onready var camera = %GameCamera

@export var speed:int = 70
@export var acceleration:int = 60
@export var last_velocity:Vector2 = Vector2.ZERO

@export var max_health:int = 100
@export var health:int = 100:
	set(new_health):
		health = clamp(new_health, 0, max_health)
		on_health_changed.emit(health,max_health)
	get:
		return health
@export var max_hunger:int = 100
@export var hunger:int = 100:
	set(new_hunger):
		hunger = clamp(new_hunger, 0, max_hunger)
	get:
		return hunger

@export var inventory_limit:int = 4
@export var inventory:Dictionary

var equipped_item = null
var equipped_id := 0
var equipped_parameters := {}
var held_item = null

var tween_life:float = 0.5

@export var interact_obj = null

enum states {idle,stunned,dead}
@export var state = states.idle

var last_dir = 0

func _input(event: InputEvent) -> void:
	if Engine.time_scale == 0: return
	if event.is_action("Test"):
		health -= 1
	if event.is_action("Test2"):
		health += 1
	if event.is_action_pressed("Interact"):
		if interact_obj and interact_obj.has_method("use"):
			interact_obj.use(self)

func _ready() -> void:
	add_new_item(load("res://Resources/Data/Weapons/scythe_stats.tres"), {}, true)
	on_health_changed.emit(health,max_health)

func _physics_process(delta: float) -> void:
	if Engine.time_scale == 0: return
	
	if Input.is_action_pressed("Use"):
		if held_item and held_item.has_method("use"):
			held_item.use(self)
	if Input.is_action_pressed("Special"):
		if held_item and held_item.has_method("special"):
			held_item.special(self)
	
	#if velocity.x > 0:
		#anim.play("run")
		#anim_player.play("runRight", tween_life)
		#anim.flip_h = true
		#
		#last_dir = "Right"
	#elif input_axis.x < 0:
		#anim.play("run")
		#anim_player.play("runLeft", tween_life)
		#anim.flip_h = false
		#
		#last_dir = "Left"
	#elif input_axis.y > 0:
		#anim.play("run")
		#if last_dir == "Left":
			#anim_player.play("runLeft", tween_life)
		#else:
			#anim_player.play("runRight", tween_life)
	#elif input_axis.y < 0:
		#anim.play("run")
		#if last_dir == "Left":
			#anim_player.play("runRight", tween_life)
		#else:
			#anim_player.play("runLeft", tween_life)
	#else:
		#anim_player.play("idle", tween_life)
		#anim.play("idle")
	
	movement(delta)
	
	move_and_slide()

func movement(delta) -> void:
	if state != states.idle:
		velocity = velocity.move_toward(Vector2.ZERO, 1400 * delta)
		return
	
	var input_axis:Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	var target_accel = acceleration*100
	var target_speed = speed*10
	var target_velocity:Vector2 = input_axis * target_speed
	velocity = Vector2(move_toward(velocity.x, target_velocity.x, target_accel * delta), move_toward(velocity.y, target_velocity.y, target_accel * delta))
	
	if input_axis != Vector2.ZERO:
		last_velocity = input_axis
	
	if velocity.x > 0:
		anim.play("run")
		anim_player.play("runRight", tween_life)
		anim.flip_h = true
		
		last_dir = 1
	elif input_axis.x < 0:
		anim.play("run")
		anim_player.play("runLeft", tween_life)
		anim.flip_h = false
		
		last_dir = -1
	elif input_axis.y > 0:
		anim.play("run")
		if last_dir < 0:
			anim_player.play("runLeft", tween_life)
		else:
			anim_player.play("runRight", tween_life)
	elif input_axis.y < 0:
		anim.play("run")
		if last_dir < 0:
			anim_player.play("runRight", tween_life)
		else:
			anim_player.play("runLeft", tween_life)
	else:
		anim_player.play("idle", tween_life)
		anim.play("idle")

func interact() -> void:
	if held_item and equipped_item and equipped_item is WeaponStats:
		held_item.use(self)

func set_hands(hand_id:int, type:int):
	var selected_hand
	var selected_type
	
	match hand_id:
		0:
			selected_hand = lHand
		1:
			selected_hand = rHand
	
	match type:
		0:
			selected_type = hand1
		1:
			selected_type = hand2
		2:
			selected_type = hand3
	
	selected_hand.texture = selected_type

func take_damage(damageDealt:int) -> void:
	if health <= 0: return
	health -= damageDealt
	camera.camera_shake(5,0.2)

func add_new_item(item_class:ItemStats, item_parameters:Dictionary, equip_now:bool=false) -> bool:
	if inventory.size() >= inventory_limit: return false
	
	inventory[str(inventory.size()+1)] = [item_class, item_parameters]
	
	var id = inventory.size()
	on_item_collected.emit(id)
	
	if equip_now: 
		equip_item(id)
		on_item_equipped.emit(id)
	
	return true

func equip_item(id:int) -> bool:
	if not inventory.has(str(id)): return false
	var item = inventory[str(id)]
	if equipped_item:
		update_item(equipped_id, equipped_parameters)
	
	equipped_item = item[0] # The Item Class
	equipped_id = id
	equipped_parameters = item[1] # The Item Parameters
	
	var new_item = load(equipped_item.item_scene_path).instantiate()
	held_item = new_item
	new_item.camera = %GameCamera
	
	on_item_equipped.emit(id)
	
	if equipped_item is WeaponStats:
		set_hands(1, 2)
		#right_slot.get_child(0).texture = equipped_item.icon
		#right_slot.get_child(0).position = equipped_item.icon_offset
		right_slot.add_child(new_item)
	else:
		set_hands(0,1)
		set_hands(1,1)
		#item_slot.get_child(0).texture = equipped_item.icon
		#item_slot.get_child(0).position = equipped_item.icon_offset
		item_slot.add_child(new_item)
	
	return true

func update_item(id:int, items_parameters:Dictionary) -> void:
	if not inventory.has(str(id)): return
	inventory[str(id)][1] = items_parameters
