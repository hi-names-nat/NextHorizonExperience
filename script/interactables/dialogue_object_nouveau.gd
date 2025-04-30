extends Node3D

@export var Tex: Texture2D
@export var RootPassages: DialogueResource

var dialogue_ui: Node
@export var counts_as_denizen: bool = true
var was_talked = false


@export var disabled = false

func _ready()-> void:
	if Tex: 
		$Sprite3D.texture = Tex
		$Sprite3D2.material_override.albedo_texture = Tex
		$Sprite3D2.texture = Tex

func object_interacted(modifier_interact, Player):
	if dialogue_ui == null:
		if disabled:
			return
		dialogue_ui =  DialogueManager.show_dialogue_balloon(RootPassages)
		dialogue_ui.viewpoint_cam = Player.main_cam
		dialogue_ui.display_node = %TextDisplayPoint
		if counts_as_denizen && !was_talked:
			Globals.set_state("denizens_talked", Globals.states_dict["denizens_talked"] + 1)
			was_talked = true
			print ("Denizens spoken to: " + str(Globals.states_dict["denizens_talked"]))
	else:
		dialogue_ui.continue_dialogue(modifier_interact)

func _process(delta: float) -> void:
	if disabled:
		disable()
	else:
		enable()

func enable():
	visible = true
	$UseTrigger.enabled = true

func disable():
	visible = false
	$UseTrigger.enabled = false

func _on_text_end() -> void:
	for child in get_children():
		if child.has_method("text_end"):
			child.text_end()
