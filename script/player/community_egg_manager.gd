extends Control
var triggered: bool = false

@export var egg_name: String
@export var egg_Desc: String
@export var egg_image: Texture2D


func _ready() -> void:
	%Chat.on_chat_sent.connect(get_chat_egg)
		


func get_chat_egg():
	await get_tree().create_timer(.25).timeout
	%Chat.close_chat()
	get_parent().get_parent().get_egg(egg_name, egg_Desc, egg_image, null)
	queue_free()
