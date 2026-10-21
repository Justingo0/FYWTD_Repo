extends Area2D

@export var current_stats: WeaponStats

@onready var cooldown_timer = $Cooldown
@onready var special_cooldown = $SpecialCooldown
@onready var animator = $Animator

@export var attacking = false
@export var camera:GameCamera = null

var last_used_player:CharacterBody2D

func use(player:CharacterBody2D) -> void:
	last_used_player = player
	if not current_stats: return
	
	if cooldown_timer.time_left != 0: return
	cooldown_timer.wait_time = current_stats.cooldown
	cooldown_timer.start()
	
	animator.stop()
	animator.play("attack")
	
	var attacking_bodies = get_overlapping_bodies()
	for body in attacking_bodies:
		if body.is_in_group("Enemy"):
			body.take_damage(current_stats.damage, player)
	if attacking_bodies.size() > 0:
		if camera:
			camera.camera_shake(2,0.3)

func special(player:CharacterBody2D):
	last_used_player = player
	if not current_stats: return
	
	if special_cooldown.time_left != 0: return
	special_cooldown.wait_time = current_stats.special_cooldown
	special_cooldown.start()
	
	animator.stop()
	animator.play("attack")
	
	var attacking_bodies = get_overlapping_bodies()
	for body in attacking_bodies:
		if body.is_in_group("Enemy"):
			body.take_damage(current_stats.damage, player)
	if attacking_bodies.size() > 0:
		if camera:
			camera.camera_shake(2,0.3)
	
	$DashParticles.emitting = true
	
	player.velocity = player.last_velocity * 1750
	player.state = player.states.stunned
	await get_tree().create_timer(0.2).timeout
	player.state = player.states.idle

func _on_body_entered(body: Node2D) -> void:
	if attacking and body.is_in_group("Enemy"):
		body.take_damage(current_stats.damage, last_used_player)
		if camera:
			camera.camera_shake(2,0.3)
