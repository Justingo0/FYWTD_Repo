extends CharacterBody2D

@onready var held_item_slot := $ItemPivot/ItemSlot
@onready var held_pivot := $ItemPivot

@export var speed:int = 70
@export var acceleration:int = 60

@export var max_health:int = 100
@export var health:int = 100
@export var max_hunger:int = 100
@export var hunger:int = 100

@export_subgroup("Inventory Variables")
@export var inventory:Array
@export var hovered_item = null

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action("Test"):
			health -= 1
		if event.is_action("Test2"):
			health += 1
		if event.is_action_pressed("Interact"):
			if hovered_item:
				hovered_item.get_child(0).disabled = true
				remove_child(hovered_item)
				inventory.append(hovered_item)

func _physics_process(delta: float) -> void:
	var input_axis:Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	var target_accel = acceleration*100
	var target_speed = speed*10
	var target_velocity:Vector2 = input_axis * target_speed
	velocity = Vector2(move_toward(velocity.x, target_velocity.x, target_accel * delta), move_toward(velocity.y, target_velocity.y, target_accel * delta))
	
	health = clamp(health, 0, max_health)
	
	move_and_slide()
