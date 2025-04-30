extends Control

var player_info = {"id": -1, "name": "", "color": Color.SNOW, "transform": Transform3D.IDENTITY, "node": null}
var ip_override = ""

signal on_player_start(player_info, ip_override)

func _process(delta: float) -> void:
	if player_info.name == "": 
		%Start.disabled = true 
	else: 
		%Start.disabled = false

func _on_name_text_submitted(new_text: String) -> void:
	player_info.name = new_text
	Globals.PLAYER_NAME = new_text

func _on_hex_text_submitted(new_text: String) -> void:
	var c = Color.from_string(new_text, Color.SNOW)
	player_info.color = c
	%NetworkPlayer.set_online_color(c)

func _on_ip_text_submitted(new_text: String) -> void:
	ip_override = new_text

func _on_pain_toggled(toggled_on: bool) -> void:
	#set some sort of global wacky feature
	pass



func _on_start_pressed() -> void:
	#spawn localplayer
	
	print(player_info)
	on_player_start.emit(player_info, ip_override)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
