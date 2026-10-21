extends Sprite2D

@export var item_stats:ItemStats

func _ready() -> void:
	if item_stats:
		texture = item_stats.icon

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.interact_obj = self

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.interact_obj == self:
			body.interact_obj = null

func use(player:CharacterBody2D) -> void:
	player.add_new_item(item_stats, {}, true)
	queue_free()
