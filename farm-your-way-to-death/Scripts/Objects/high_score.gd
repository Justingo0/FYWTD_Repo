extends Label

func _ready() -> void:
	text = "HS: " + str(GameManager.highscore)
	await get_tree().create_timer(3).timeout
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
