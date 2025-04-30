extends Control
var triggered: bool = false

@export var egg_name: String
@export var egg_Desc: String
@export var egg_image: Texture2D


func _ready() -> void:
	Globals.state_changed.connect(get_chatty_egg)
		


func get_chatty_egg(key, entry):
	if key == "denizens_talked" and entry == Globals.num_denizens:
		await get_tree().create_timer(.25).timeout
		get_parent().get_parent().get_egg(egg_name, egg_Desc, egg_image, null)
		queue_free()
