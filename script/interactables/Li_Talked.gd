extends Node3D

func _process(delta: float) -> void:
	get_parent().disabled = Globals.has_met_li
