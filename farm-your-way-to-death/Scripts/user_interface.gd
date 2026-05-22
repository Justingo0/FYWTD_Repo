extends Control

@onready var player_char = %PlayerCharacter
@onready var healthBar := $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	healthBar.max_value = player_char.max_health
	healthBar.value = player_char.health
