extends Area2D

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.get_class() == "CharacterBody2D":
		body.hovered_item = self

func _on_body_exited(body: Node2D) -> void:
	if body.get_class() == "CharacterBody2D":
		if body.hovered_item == self:
			body.hovered_item = null
