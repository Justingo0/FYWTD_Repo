extends Node2D

@onready var ghost_enemy = preload("res://Scenes/Objects/Enemies/ghost.tscn")
@onready var spawn_timer = $SpawnTime

func _ready() -> void:
	GameManager.on_score_changed.connect(func():
			spawn_timer.wait_time -= 0.0005
			spawn_timer.wait_time = max(spawn_timer.wait_time, 0.15)
			)

func spawn_enemy(enemy_scene:PackedScene=null):
	var enemy_object:Node2D
	if enemy_scene:
		enemy_object = enemy_scene.instantiate()
	else:
		enemy_object = ghost_enemy.instantiate()
	
	var chosen_pos = Vector2(randf_range(-1500,1500),randf_range(-870,870))
	var pos_length = chosen_pos.length()
	if pos_length < 870 and pos_length > 0:
		chosen_pos = chosen_pos.normalized() * 870
	
	enemy_object.nearest_player = %PlayerCharacter
	
	enemy_object.global_position = chosen_pos
	get_tree().current_scene.add_child(enemy_object)

func _on_spawn_time_timeout() -> void:
	spawn_enemy()
