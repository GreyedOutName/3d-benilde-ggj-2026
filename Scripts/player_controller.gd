# ProtoController v1.0 by Brackeys
# CC0 License
# Intended for rapid prototyping of first-person games.
# Happy prototyping!

extends CharacterBody3D

## Can we move around?
@export var can_move : bool = true
## Are we affected by gravity?
@export var has_gravity : bool = true
## Can we press to jump?
@export var can_jump : bool = true
## Can we hold to run?
@export var can_sprint : bool = false
## Can we press to enter freefly mode (noclip)?
@export var can_freefly : bool = false
## Can we interact with objects?
@export var can_interact : bool = true

@export_group("Speeds")
## Look around rotation speed.
@export var look_speed : float = 0.002
## Normal speed.
@export var base_speed : float = 8
## Speed of jump.
@export var jump_velocity : float = 4.5
## How fast do we run?
@export var sprint_speed : float = 10.0
## How fast do we freefly?
@export var freefly_speed : float = 25.0

@export_group("Interaction")
## Interaction distance (raycast length).
@export var interact_distance : float = 3.0
## Input action for interacting.
@export var input_interact : String = "interact"

@export_group("Input Actions")
## Name of Input Action to move Left.
@export var input_left : String = "ui_left"
## Name of Input Action to move Right.
@export var input_right : String = "ui_right"
## Name of Input Action to move Forward.
@export var input_forward : String = "ui_up"
## Name of Input Action to move Backward.
@export var input_back : String = "ui_down"
## Name of Input Action to Jump.
@export var input_jump : String = "ui_accept"
## Name of Input Action to Sprint.
@export var input_sprint : String = "sprint"
## Name of Input Action to toggle freefly mode.
@export var input_freefly : String = "freefly"

var mouse_captured : bool = false
var look_rotation : Vector2
var move_speed : float = 0.0
var freeflying : bool = false
var current_interactable : Node = null

## Dialogue state
var in_dialogue : bool = false

## IMPORTANT REFERENCES
@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider
@onready var interaction_ray: RayCast3D = $Head/InteractionRay
@onready var crosshair_dot: Label = $UI/Crosshair/CrosshairDot
@onready var interact_label: Label = $UI/Crosshair/InteractLabel

func _ready() -> void:
	check_input_mappings()
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	# Set up interaction ray distance
	if interaction_ray:
		interaction_ray.target_position = Vector3(0, 0, -interact_distance)
	# Add player to group for NPC detection
	add_to_group("player")
	GlobalSignals.end_dialogue.connect(_end_dialogue)
	capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	
	# Look around
	if mouse_captured and event is InputEventMouseMotion:
		rotate_look(event.relative)
	
	# Toggle freefly mode
	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()
	
	# Handle interaction
	if can_interact and Input.is_action_just_pressed(input_interact):
		try_interact()

func _physics_process(delta: float) -> void:
	# If freeflying, handle freefly and nothing else
	if can_freefly and freeflying:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		move_and_collide(motion)
		return
	
	# Apply gravity to velocity
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Apply jumping
	if can_jump:
		if Input.is_action_just_pressed(input_jump) and is_on_floor():
			velocity.y = jump_velocity

	# Modify speed based on sprinting
	if can_sprint and Input.is_action_pressed(input_sprint):
			move_speed = sprint_speed
	else:
		move_speed = base_speed

	# Apply desired movement to velocity
	if can_move:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if move_dir:
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
	else:
		velocity.x = 0
		velocity.y = 0
	
	# Use velocity to actually move
	move_and_slide()
	
	# Check for interactable objects
	if can_interact:
		check_interaction()


## Rotate us to look around.
## Base of controller rotates around y (left/right). Head rotates around x (up/down).
## Modifies look_rotation based on rot_input, then resets basis and rotates by look_rotation.
func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)


func enable_freefly():
	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false


func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false


## Checks if some Input Actions haven't been created.
## Disables functionality accordingly.
func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false
	if can_move and not InputMap.has_action(input_forward):
		push_error("Movement disabled. No InputAction found for input_forward: " + input_forward)
		can_move = false
	if can_move and not InputMap.has_action(input_back):
		push_error("Movement disabled. No InputAction found for input_back: " + input_back)
		can_move = false
	if can_jump and not InputMap.has_action(input_jump):
		push_error("Jumping disabled. No InputAction found for input_jump: " + input_jump)
		can_jump = false
	if can_sprint and not InputMap.has_action(input_sprint):
		push_error("Sprinting disabled. No InputAction found for input_sprint: " + input_sprint)
		can_sprint = false
	if can_freefly and not InputMap.has_action(input_freefly):
		push_error("Freefly disabled. No InputAction found for input_freefly: " + input_freefly)
		can_freefly = false
	if can_interact and not InputMap.has_action(input_interact):
		push_warning("No InputAction found for input_interact: " + input_interact + ". Using 'ui_accept' as fallback.")
		input_interact = "ui_accept"


## Check if we're looking at an interactable object and update UI accordingly.
func check_interaction():
	if not interaction_ray:
		return
	# Skip raycast check if we already have an interactable from Area3D (like NPC)
	# This prevents the raycast from overriding NPC interaction prompts
	if current_interactable and current_interactable.is_in_group("npc"):
		return
	
	if interaction_ray.is_colliding():
		var collider_obj = interaction_ray.get_collider()
		# Check if the object is in the "interactable" group
		if collider_obj and collider_obj.is_in_group("interactable"):
			current_interactable = collider_obj
			show_interact_prompt()
			return
	
	# Not looking at anything interactable
	current_interactable = null
	show_crosshair()


## Show the crosshair and hide interact text.
func show_crosshair():
	if crosshair_dot:
		crosshair_dot.visible = true
	if interact_label:
		interact_label.visible = false


## Show the interact text and hide crosshair.
func show_interact_prompt():
	if crosshair_dot:
		crosshair_dot.visible = false
	if interact_label:
		interact_label.visible = true
		
func hide_crosshair():
	crosshair_dot.visible = false
	interact_label.visible = false


## Try to interact with the current interactable object.
func try_interact():
	if current_interactable and current_interactable.has_method("interact"):
		release_mouse()
		hide_crosshair()
		current_interactable.interact()

#ALL FUNCTIONS HERE CONNECT TO GLOBAL SIGNAL
## End the dialogue and restore player control.
func _end_dialogue() -> void:
	in_dialogue = false
	# Re-enable movement
	can_move = true
	# Show crosshair
	show_crosshair()
	# Capture Mouse Again
	capture_mouse()
