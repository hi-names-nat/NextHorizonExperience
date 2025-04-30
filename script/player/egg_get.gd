extends Control

var current_egg_name = ""
var num_eggs = 0
@export var total_eggs = 20

var eggNode = null

signal egg_accepted(egg_name: String)
signal all_eggs

func populate_and_enable(egg_name: String, egg_desc: String, egg_image: Texture2D, node: Node3D):
	current_egg_name = egg_name
	%EggName.text = "You got %s" % egg_name
	%EggDesc.text = egg_desc
	%EggTex.texture = egg_image
	eggNode = node
	visible = true
	num_eggs+=1
	


func _on_okay_pressed() -> void:
	egg_accepted.emit(current_egg_name)
	if num_eggs == total_eggs:
		all_eggs.emit()
	if eggNode != null:
		eggNode.queue_free()
		eggNode = null
