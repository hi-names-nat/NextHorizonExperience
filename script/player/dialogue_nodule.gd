extends Control

@export var ViewpointCamera: Camera3D

var display_node: Node3D = null

func start(node, _what):
	#DialogueManager.show_
	display_node = node

func create_dialogue_node(res: DialogueResource, title: String ="", extra_game_states: Array= []):
	pass
func _process(_delta) -> void:
	
	# This code block is part of a script that inherits from Node3D.
	# 		`control` is a reference to a node inheriting from Control.
	
	if display_node == null: return
	else:
		visible = not ViewpointCamera.is_position_behind(display_node.global_transform.origin)
		# multiply by 4 to transform it over 
		position = ViewpointCamera.unproject_position(display_node.global_transform.origin) * 4
