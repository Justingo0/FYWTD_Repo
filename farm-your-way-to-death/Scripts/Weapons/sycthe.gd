extends Area2D

@onready var animator = $AnimationPlayer
@onready var cooldown_timer = $CooldownTimer

@export var damage:int
@export var cooldown_time:float

func _ready() -> void:
	cooldown_timer.wait_time = cooldown_time

func use():
	if cooldown_timer.time_left != 0: return
	
	animator.play("attack")
	
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.start()
	await cooldown_timer.timeout
