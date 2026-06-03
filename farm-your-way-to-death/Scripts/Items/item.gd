extends Sprite2D

@export var item:PackedScene = null
@export var is_weapon:bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.closest_item = self

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.closest_item == self:
			body.closest_item = null
