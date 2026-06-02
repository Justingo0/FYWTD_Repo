extends Sprite2D

@export var item:PackedScene
@export var sprite:CompressedTexture2D

var closest_player = null

func _ready():
	texture = sprite

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.closest_item = self

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.closest_item == self:
		body.closest_item = null
