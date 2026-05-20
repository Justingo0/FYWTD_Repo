extends CharacterBody2D

@export var speed:int = 70
@export var acceleration:int = 60

@export var health:int = 100
@export var hunger:int = 100

func _physics_process(delta: float) -> void:
	var input_axis:Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	
	var target_accel = acceleration*100
	var target_speed = speed*10
	
	var target_velocity:Vector2 = input_axis * target_speed
	   
	velocity = Vector2(move_toward(velocity.x, target_velocity.x, target_accel * delta), move_toward(velocity.y, target_velocity.y, target_accel * delta))
	
	move_and_slide()
