extends CharacterBody3D

const VECTOR3_INVALID = Vector3(-1.79769e307, -1.79769e307, -1.79769e307)

var interactable_looked_at: Object

var input_disabled: bool = false
var input_override: bool = false

var is_crouching: bool
var stand_height: float

@export var chat: Control

const CROUCH_HEIGHT = 1.4
var SPEED = 4.5
const CROUCH_SPEED = 2.5
const LOOK_SENSITIVITY = 0.5

@export_subgroup("Mouse Settings")
@export var invert_mouse_x : bool = true 
@export var invert_mouse_y : bool = true
@export var mouse_sensitivity: Vector2 = Vector2(5,5)

@export var max_step_height: float = 0.4
var _snapped_to_stairs_last_frame : bool = false
var _last_frame_was_on_floor = -INF

var mouse_input: Vector2

var player_name: String

@onready var main_cam = %MainCam

#@onready var dialogue = %DialogueNodule

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var viewport_transform: Transform2D = get_tree().root.get_final_transform()
		mouse_input += event.xformed_by(viewport_transform).relative

func _init() -> void:
	pass

func _ready() -> void:
	stand_height = ($CollisionShape3D.shape as CapsuleShape3D).height
	#%CamPos.rotation = Vector3(0,0,0)
	%PlayerUI.set_custom_viewport(%CamPos.get_viewport())
	%PlayerUI.follow_viewport_enabled = true
	%Chat.on_chat_exit.connect(func(): input_disabled = false)
	%Chat.on_chat_sent.connect(func(): input_disabled = false)

func _process(delta: float) -> void:
	mouse_input = Vector2.ZERO
	%TextCam.global_transform = %CamPos.global_transform
	%MainCam.global_transform = %CamPos.global_transform
	if Input.is_action_just_pressed("player_exit"):
		input_override = !input_override

func _physics_process(delta: float) -> void:
	if input_disabled or input_override:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	_calculate_movement(delta)
	_calculate_look(delta)
	
	if Input.is_key_pressed(KEY_BRACERIGHT): 
		SPEED = 10.0
	if Input.is_key_pressed(KEY_BRACELEFT):
		SPEED = 3.0
		
	
	_notify_player_look() 	
	
	if Input.is_action_just_pressed("player_interact"):
		_notify_interact()

	if Input.is_action_pressed("player_crouch"):
		_crouch()
	elif Input.is_action_just_released("player_crouch"):
		_stand()
	
	if Input.is_action_just_pressed("player_crouch_toggle"):
		_crouch_toggle()
		
	if Input.is_action_just_pressed("player_num_1"):
		_notify_interact(1)
	if Input.is_action_just_pressed("player_num_2"):
		_notify_interact(2)
	if Input.is_action_just_pressed("player_num_3"):
		_notify_interact(3)
	if Input.is_action_just_pressed("player_num_4"):
		_notify_interact(4)
	if Input.is_action_just_pressed("player_num_5"):
		_notify_interact(5)
	if Input.is_action_just_pressed("ui_accept"):
		input_disabled = true
		%Chat.open_chat()
	%Chat.player_name = player_name

func set_camera_rotation(val: Vector3):
	print(val)
	%CamPos.rotation = val * basis

func _calculate_look(delta: float) -> void:
	var mouseInversions: Vector2 = Vector2(-1 if invert_mouse_x else 1, -1 if invert_mouse_y else 1)
	
	var CameraInput: Vector2 = (mouse_input * .001) * mouse_sensitivity * mouseInversions
	
	#rotate viewpoint/player body
	if %CamPos.rotation_degrees.x + CameraInput.y >= 90:
		%CamPos.rotation_degrees.x = 90	
	elif %CamPos.rotation_degrees.x + CameraInput.y <= -90:
		%CamPos.rotation_degrees.x = -90	
	else:
		%CamPos.rotate_object_local(Vector3(1,0,0), CameraInput.y)
	rotate(Vector3(0, 1, 0), CameraInput.x)
	
func _calculate_movement(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		_last_frame_was_on_floor = Engine.get_physics_frames()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("player_left", "player_right", "player_forward", "player_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_crouching:
			velocity.x = direction.x * CROUCH_SPEED
			velocity.z = direction.z * CROUCH_SPEED
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if !_snap_up_stairs_check(delta):
		move_and_slide()
		_snap_down_to_stairs_check()

func _notify_player_look() -> void:
	if %InteractCast.is_colliding():
		var obj = %InteractCast.get_collider()
		#prevents queue_free from deleting obj between this and the next frame without the correct clearing.
		if obj == null: 
			print('null')
			return
		obj.player_lookat(self)
		interactable_looked_at = obj
	elif interactable_looked_at != null:
		interactable_looked_at.player_stop_look(self)
		interactable_looked_at = null

func _notify_interact(mod_value: int = 0) -> void:
	if %InteractCast.is_colliding():
		
		print("colliding with ", %InteractCast.get_collider().name)
		var obj = %InteractCast.get_collider()
		obj.use_object(mod_value)

#todo: crouch
func _crouch() -> void:
	%CamPos.position = $Camera_crouchpos.position
	($CollisionShape3D.shape as CapsuleShape3D).height = CROUCH_HEIGHT
	is_crouching = true

func _stand() -> void:
	%CamPos.position = $Camera_standpos.position
	($CollisionShape3D.shape as CapsuleShape3D).height = stand_height
	is_crouching = false

func _crouch_toggle() -> void:
	if is_crouching:
		_stand()
	else:
		_crouch()

#func set_player_input_prompt(str):
	#%DialogueOptions.text = str
	#%DialogueOptions.visible = true
	#%ExplainPrompt.visible = true
#
#func clear_player_input_prompt():
	#%DialogueOptions.text = ""
	#%DialogueOptions.visible = false
	#%ExplainPrompt.visible = false

#Stairs logic, stolen basically wholesale from https://youtu.be/Tb-R3l0SQdc?si=0cWy6AenjvXxH0K8. remember to credit.

func get_egg(egg_name: String, egg_desc: String, egg_image: Texture2D, node: Node3D):
	input_disabled = true
	%EggGet.populate_and_enable(egg_name, egg_desc, egg_image, node)
	input_disabled = true

func confirm_egg(egg_name):
	%Chat.propogate_chat_from_outside(("%s got "+ egg_name))
	%EggGet.visible = false
	input_disabled = false
	
func all_eggs():
	%Chat.propogate_chat_from_outside("%s got ALL EGGS! Congrats! Remember to screenshot this message.")
	
func is_surface_too_steep(normal: Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle
	
func _run_body_test_motion(from: Transform3D, motion: Vector3, result = null) -> bool:
	if not result: result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)

func _snap_down_to_stairs_check() -> void:
	var did_snap = false
	var floor_below : bool = %StairsBelow.is_colliding() and !is_surface_too_steep(%StairsBelow.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() - _last_frame_was_on_floor == 1
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var res = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(self.global_transform, Vector3(0, -max_step_height, 0), res):
			var translate_y = res.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
		_snapped_to_stairs_last_frame = did_snap

func _snap_up_stairs_check(delta) -> bool:
	if !is_on_floor() and !_snapped_to_stairs_last_frame: return false
	var expected_move = self.velocity * Vector3(1,0,1) * delta
	var step_pos_w_clearance = self.global_transform.translated(expected_move + Vector3(0, max_step_height * 2, 0))
	
	var res = PhysicsTestMotionResult3D.new()
	if (_run_body_test_motion(step_pos_w_clearance, Vector3(0, -max_step_height*2,0), res)
	and (res.get_collider().is_class("StaticBody3D") or res.get_collider().is_class("CSGShape3D"))):
		var step_height = ((step_pos_w_clearance.origin + res.get_travel()) - self.global_position).y
		
		if step_height > max_step_height or step_height <= 0.01 or (res.get_collision_point() - self.global_position).y > max_step_height: return false
		%StairsAhead.global_position = res.get_collision_point() + Vector3(0,max_step_height,0) + expected_move.normalized() * 0.1
		%StairsAhead.force_raycast_update()
		if %StairsAhead.is_colliding() and !is_surface_too_steep(%StairsAhead.get_collision_normal()):
			self.global_position = step_pos_w_clearance.origin + res.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false
