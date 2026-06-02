extends CharacterBody2D

@onready var spriteAnim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@onready var cooldown_timer = $Cooldown

@export var speed:float
@export var damage:int = 6
@export var attack_cooldown:float = 1
@export var health:int

var nearestPlayer:CharacterBody2D
var attacking:CharacterBody2D

var is_dead := false

func _ready() -> void:
	cooldown_timer.wait_time = attack_cooldown
	nearestPlayer = %PlayerCharacter
	
	add_to_group("Enemy")

func _on_animated_sprite_2d_frame_changed() -> void:
	if spriteAnim.animation == "attack" and spriteAnim.frame == 3:
		if attacking:
			attacking.take_damage(damage)

func attack():
	if is_dead: return
	
	spriteAnim.play("attack")
	cooldown_timer.start()
	
	await spriteAnim.animation_finished
	
	if is_dead: return
	spriteAnim.play("move")

func _physics_process(delta: float) -> void:
	if not nearestPlayer or is_dead: return
	
	if (nearestPlayer.global_position - global_position).length() > 120:
		var target_speed = speed*100
		velocity = global_position.direction_to(nearestPlayer.global_position) * target_speed * delta
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
	if attacking and cooldown_timer.time_left == 0:
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

func take_damage(damageDealt):
	health -= damageDealt
	if health <= 0:
		spriteAnim.play("hurt")
		animPlayer.play("death")
		is_dead = true
		await animPlayer.animation_finished
		queue_free()
		
		return
	animPlayer.play("hurt")
	spriteAnim.play("hurt")
	is_dead = true
	await animPlayer.animation_finished
	animPlayer.play("RESET")
	spriteAnim.play("move")
	is_dead = false
