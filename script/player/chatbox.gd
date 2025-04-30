extends Control

@export var chat_element: PackedScene
@export var chat_container: Control

var player_name: String

signal on_chat_sent
signal on_chat_exit

func _ready():
	%ChatInput.text_submitted.connect(func(e: String): 
		print("text submitted")
		await get_tree().create_timer(.05).timeout
		print(e)
		if e == "":
			close_chat()
			return
		visible = false
		%ChatInput.visible = false
		%ChatInput.text = ""
		send_chat_remote("%s: %s" % [player_name, e])
		rpc("send_chat_remote", "%s: %s" % [player_name, e])
		on_chat_sent.emit()
		)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("player_exit"):
		close_chat()
	
func close_chat():
	%ChatInput.visible = false
	visible=false
	on_chat_exit.emit()

func open_chat():
	visible = true
	%ChatInput.visible = true
	%ChatInput.grab_focus()
	$ChatTimer.stop()

func propogate_chat_from_outside(text, no_player_name = false):
	send_chat_remote(text % [player_name])
	rpc(text, "%s: %s" % [player_name])

@rpc("any_peer")
func send_chat_remote(text):
	if multiplayer.is_server():
		print(text)
	visible = true
	var c = chat_element.instantiate()
	chat_container.add_child(c)
	
	if chat_container.get_child_count() == 10:
		chat_container.get_child(0).queue_free()
	c.set_text(text)
	$ChatTimer.timeout.connect(func(): 
		visible = false)
	$ChatTimer.start()
