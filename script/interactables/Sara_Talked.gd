extends Node3D

@export var reverse = false

func _process(delta: float) -> void:
	get_parent().disabled = (Globals.has_met_sara && Globals.has_met_li)
	if reverse: get_parent().disabled = !get_parent().disabled
