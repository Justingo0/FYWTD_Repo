extends Control

@onready var player_char = %PlayerCharacter
@onready var healthBar := $ProgressBar

func _process(_float) -> void:
	healthBar.max_value = player_char.max_health
	healthBar.value = player_char.health
