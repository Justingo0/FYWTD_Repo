extends Control

@onready var player_char = %PlayerCharacter
@onready var health_bar = $ProgressBar

@onready var score_counter = $Score
@onready var combo_counter = $Score/Combo
@onready var combo_animator = $Score/Combo/AnimationPlayer
@onready var score_increment_timer = $Score/ScoreIncrement
@onready var combo_break_timer = $Score/ComboBreakTime

@onready var pause_screen = $PauseScreen

#@onready var camera = %GameCamera

var high_score_passed := false

var combo := 1:
	set(new_val):
		combo = max(new_val,1)
		GameManager.combo = combo
		if combo_counter:
			if combo <= 1:
				combo_counter.visible = false
			else:
				combo_counter.visible = true
			combo_counter.text = "x" + str(combo)
			combo_counter.scale = Vector2(1.5,1.5)
			var tween = create_tween()
			tween.tween_property(combo_counter, "scale", Vector2(1,1), 0.2)
			tween.play()
	get:
		return combo

var score := 0:
	set(new_val):
		score = max(new_val,0)
		GameManager.score = score
		update_score(score)
	get:
		return score

func get_if_mobile() -> bool:
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"):
		return true
	return false

func _ready() -> void:
	$MobileControls.visible = false
	$PauseButton.visible = false
	if get_if_mobile():
		$MobileControls.visible = true
		$PauseButton.visible = true
	
	combo_animator.play("rotate")
	combo_counter.text = "x" + str(combo)
	if player_char:
		player_char.on_item_collected.connect(new_player_item)
		player_char.on_item_equipped.connect(new_player_item)
		
		player_char.on_health_changed.connect(on_health_changed)
		
		player_char.on_enemy_killed.connect(on_enemy_killed)
	
	GameManager.on_score_changed.connect(func():
			if GameManager.highscore == 0:
				high_score_passed = true
			if GameManager.score > GameManager.highscore:
				GameManager.highscore = GameManager.score
				if high_score_passed: return
				high_score_passed = true
				$Annoucement.visible = true
				$Annoucement/AnimationPlayer.play("rotate")
				await get_tree().create_timer(3).timeout
				var tween = create_tween()
				tween.tween_property($Annoucement, "modulate:a", 0, 1)
			)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		Engine.time_scale = 0 if Engine.time_scale == 1 else 1
		pause_screen.visible = true if Engine.time_scale == 0 else false

func on_health_changed(health:int,max_health:int):
	if health < health_bar.value:
		score -= 5
		score_increment_timer.start()
	health_bar.max_value = max_health
	health_bar.value = health

func new_player_item(_id:int):
	if not player_char: return
	#var item_class = player_char.inventory[str(id)][0]

func on_enemy_killed():
	combo += 1
	score += 40 + int(0.05*combo)
	print(40 + int(0.1*combo))
	combo_break_timer.start()
	
	var counter_rotation = [-0.05*min(combo,25),0.05*min(combo,25)]
	score_counter.rotation = deg_to_rad(counter_rotation.pick_random())
	score_counter.scale = Vector2(1.5+(0.03*min(combo,25)),1.5+(0.03*min(combo,25)))
	
	var tween = create_tween()
	tween.tween_property(score_counter, "scale", Vector2(1,1), 0.2)
	tween.tween_property(score_counter, "rotation", 0, 0.2)
	tween.play()

func update_score(value:int):
	score_counter.text = str(value)

func _on_score_increment_timeout() -> void:
	score += 5

func _on_combo_break_time_timeout() -> void:
	combo = 1

#func _on_special_button_button_down() -> void:
	#var release_event = InputEventAction.new()
	#release_event.action = "jump"
	#release_event.pressed = false
	#Input.parse_input_event(release_event)
#
#func _on_special_button_button_up() -> void:
	#var event = InputEventAction.new()
	#event.action = "Special"
	#event.pressed = false
	#Input.parse_input_event(event)

func _on_attack_button_button_down() -> void:
	Input.action_press("Use")

func _on_attack_button_button_up() -> void:
	Input.action_release("Use")

func _on_special_button_button_down() -> void:
	Input.action_press("Special")

func _on_special_button_button_up() -> void:
	Input.action_release("Special")

func _on_pause_button_pressed() -> void:
	if not get_if_mobile(): return
	Engine.time_scale = 0 if Engine.time_scale == 1 else 1
	pause_screen.visible = true if Engine.time_scale == 0 else false
