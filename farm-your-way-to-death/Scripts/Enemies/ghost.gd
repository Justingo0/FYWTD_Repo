extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var shadow_texture = $Shadow
@onready var anim_player = $AnimationPlayer

@onready var cooldown_timer = $Cooldown
@onready var stunned_timer = $StunnedTimer

@export var speed:float
@export var damage:int = 6
@export var attack_cooldown:float = 1
@export var health:int = 10

@export var nearest_player:CharacterBody2D
var attacking:CharacterBody2D

enum states {alive, attacking, stunned, dead}
var state = states.alive

var knockback: Vector2 = Vector2.ZERO

func _ready() -> void:
	cooldown_timer.wait_time = attack_cooldown
	anim_player.play("move")

func _physics_process(delta: float) -> void:
	movement(delta)
	move_and_slide()

func movement(delta:float):
	if not nearest_player: return
	if state == states.alive:
		var nearest_pos = nearest_player.global_position-Vector2(0,52)
		if not attacking:
			var target_speed = speed*100
			velocity = global_position.direction_to(nearest_pos) * target_speed * delta
			if not cooldown_timer.is_stopped():
				cooldown_timer.stop()
		else:
			velocity = Vector2.ZERO
			if cooldown_timer.is_stopped():
				anim_player.play("attack")
				state = states.attacking
				await anim_player.animation_finished
				cooldown_timer.start()
				state = states.alive
				anim_player.play("move")
	
	if state == states.stunned:
		knockback = knockback.move_toward(Vector2.ZERO, 1400 * delta)
		velocity = knockback
	
	if nearest_player.global_position.x > global_position.x:
		sprite.flip_h = false
		shadow_texture.flip_h = false
	else:
		sprite.flip_h = true
		shadow_texture.flip_h = true

func attack():
	if state == states.dead or state == states.stunned: return
	if attacking:
		attacking.take_damage(damage)

func _on_cooldown_timeout() -> void:
	anim_player.play("attack")
	state = states.attacking
	await anim_player.animation_finished
	state = states.alive
	anim_player.play("move")

func _on_hitbox_body_entered(body: Node2D) -> void:
	if nearest_player == body:
		attacking = body

func _on_hitbox_body_exited(body: Node2D) -> void:
	if attacking == body:
		attacking = null

func take_damage(damage_dealt:int, attacker:Node2D, kbF):
	if damage_dealt <= 0.0 or state == states.dead or state == states.stunned: return
	health -= damage_dealt
	apply_knockback(kbF, attacker)
	if health <= 0:
		if attacker.has_signal("on_enemy_killed"):
			attacker.on_enemy_killed.emit()
		anim_player.play("death")
		state = states.dead
		return
	
	anim_player.play("hurt")
	stunned_timer.start()
	state = states.stunned

func apply_knockback(force:float, attacker:Node2D):
	velocity = Vector2.ZERO
	var direction = global_position.direction_to(attacker.global_position)
	knockback = -direction*force

func _on_stunned_timer_timeout() -> void:
	anim_player.play("move")
	state = states.alive
