extends CharacterBody2D

@onready var spriteAnim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@onready var cooldown_timer = $Cooldown

@export var speed:float
@export var damage:int
@export var attack_cooldown:float
@export var health:int

var nearestPlayer:CharacterBody2D
var attacking:CharacterBody2D

func _ready() -> void:
	cooldown_timer.wait_time = attack_cooldown
	nearestPlayer = %PlayerCharacter

func _on_animated_sprite_2d_frame_changed() -> void:
	if spriteAnim.animation == "attack" and spriteAnim.frame == 2:
		hurt()

func attack():
	if cooldown_timer.time_left != 0: return
	
	spriteAnim.play("attack")
	cooldown_timer.start()
	await spriteAnim.animation_finished
	spriteAnim.play("move")

func hurt():
	if attacking:
		attacking.take_damage(damage)

func _physics_process(delta: float) -> void:
	if not nearestPlayer: return
	
	var target_speed = speed*100
	velocity = global_position.direction_to(nearestPlayer.global_position) * target_speed * delta
	move_and_slide()
	
	if attacking:
		attack()
	
	if velocity.x > 0:
		spriteAnim.flip_h = false
	elif velocity.x < 0:
		spriteAnim.flip_h = true

func _on_hitbox_body_entered(body: Node2D) -> void:
	if nearestPlayer == body:
		attacking = body

func _on_hitbox_body_exited(body: Node2D) -> void:
	if attacking == body:
		attacking = null
