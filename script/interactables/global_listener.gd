extends Node3D

@export var expected_key: String
@export var expected_state: int 
@export var objects_to_enable: Array[Node3D]

func _ready() -> void:
	Globals.state_changed.connect(state_changed)

func state_changed(key, dict):
	if key != expected_key: return
	if (dict == expected_state):
		for objects in objects_to_enable:
			objects.disabled = false
			objects.visible = true
