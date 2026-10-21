extends Control

@onready var player_char = %PlayerCharacter
@onready var health_bar = $ProgressBar

@onready var score_counter = $Score
@onready var combo_break_timer = $Score/ComboBreakTime

@onready var pause_screen = $PauseScreen


var combo := 0

var score := 0:
	set(new_val):
		score = new_val
		update_score(score)
	get:
		return score

func _ready() -> void:
	if player_char:
		player_char.on_item_collected.connect(new_player_item)
		player_char.on_item_equipped.connect(new_player_item)
		
		player_char.on_health_changed.connect(on_health_changed)
		
		player_char.on_enemy_killed.connect(on_enemy_killed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		Engine.time_scale = 0 if Engine.time_scale == 1 else 1
		pause_screen.visible = true if Engine.time_scale == 0 else false

func on_health_changed(health:int,max_health:int):
	health_bar.max_value = max_health
	health_bar.value = health

func new_player_item(id:int):
	if not player_char: return
	var item_class = player_char.inventory[str(id)][0]

func on_enemy_killed():
	combo += 1
	score += 20
	combo_break_timer.start()
	print(combo)
	
	var rotation = [-0.2*combo,0.2*combo]
	score_counter.rotation = deg_to_rad(rotation.pick_random())
	score_counter.scale = Vector2(1.5+(0.03*min(combo,25)),1.5+(0.03*min(combo,25)))
	
	var tween = create_tween()
	tween.tween_property(score_counter, "scale", Vector2(1,1), 0.2)
	tween.tween_property(score_counter, "rotation", 0, 0.2)
	tween.play()

func update_score(value:int):
	score_counter.text = str(value)

func _on_score_increment_timeout() -> void:
	score += 1

func _on_combo_break_time_timeout() -> void:
	combo = 0
