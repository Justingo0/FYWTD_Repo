extends Node

signal on_score_changed
signal on_combo_changed

var highscore := 0
var score := 0:
	set(new_val):
		score = max(new_val,0)
		on_score_changed.emit()
	get:
		return score
var combo := 1:
	set(new_val):
		combo = max(new_val,0)
		on_combo_changed.emit()
	get:
		return combo
