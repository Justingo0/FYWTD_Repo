extends Sprite2D

@export var item:PackedScene = null
@export var is_weapon:bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.interact_obj = self

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.interact_obj == self:
			body.interact_obj = null

func use():
	print("Tehe")
