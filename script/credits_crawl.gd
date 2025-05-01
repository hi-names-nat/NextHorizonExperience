extends RichTextLabel

var default_pos

@export var speed = 1
func _ready() -> void:
	default_pos = position

func _physics_process(delta: float) -> void:
	if visible:
		position.y -= delta * speed
	else:
		position = default_pos
