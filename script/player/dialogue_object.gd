extends Node3D

@export var Tex: Texture2D
@export var RootPassages: Resource

@export var disabled = false

func _ready()-> void:
	$GFloatingText.set_passage_root(RootPassages)
	$Sprite3D.texture = Tex
	$Sprite3D2.material_override.albedo_texture = Tex
	$Sprite3D2.texture = Tex

func enable():
	visible = true
	$UseTrigger.enabled = true

func disable():
	visible = false
	$UseTrigger.enabled = false

func _on_text_end() -> void:
	for child in get_children():
		if child.has_method("text_end"):
			child.text_end()
