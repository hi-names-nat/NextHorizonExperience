extends Node3D

@export var transparency = 0.6
@export var speed = 0.5

func _ready() -> void:
	var c = Color.SNOW
	c.a = transparency
	$NetPlayer_Mesh.get_active_material(0).albedo_color = c

func set_online_color(color: Color):
	if color.a == 1: 
		color.a = transparency
	$NetPlayer_Mesh.get_active_material(0).albedo_color = color

func set_online_name(name: String):
	pass

func _process(delta: float) -> void:
	rotate(Vector3.UP, speed * delta)
