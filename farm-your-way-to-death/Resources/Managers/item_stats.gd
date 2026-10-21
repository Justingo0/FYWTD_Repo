extends Resource
class_name ItemStats

@export_category("Identity")
@export var name:String
#The inventory icon and not the weapon's sprite
@export var icon:Texture2D
@export_group("Settings")
@export var icon_offset:Vector2

@export_group("")
@export_file("*.tscn", "*.scn") var item_scene_path:String

func _init() -> void:
	if not icon:
		icon = load("res://Assets/Objects/missing_texture.png")
	if not name:
		name = "NAN"
	#if not item_scene_path:
		#item_scene_path = load("res://Resources/Data/Items/test_item.tres")
