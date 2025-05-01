extends Button
@export var items_to_disable: Array[Control]
@export var items_to_enable: Array[Control]




func _on_pressed() -> void:
	for item in items_to_disable:
		item.visible = false
	for item in items_to_enable:
		item.visible = true
