extends Node3D
@export var switch_objects: Array[Node3D]
@export var do_once: bool = true

var used: bool = false


func object_interacted(modifier_interact, Player):
	_on_use_component_on_interacted(Player)

func _on_use_component_on_interacted(player: Node3D) -> void:
	if (used && do_once): return
	
	for obj in switch_objects:
		obj.visible = true
		obj.disabled = false
