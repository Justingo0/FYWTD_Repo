extends Area2D

@onready var animator = $AnimationPlayer

@export var damage:int
@export var cooldown_time:float

var cooldown:float

func use():
	animator.play("attack")
