
extends Node3D
class_name Interactable

## Signal emitted when the player enters the interaction area.
signal player_entered
## Signal emitted when the player exits the interaction area.
signal player_exited

## The dialogue lines this NPC will say.
@export var dialogue_resource: DialogueResource
## Custom interact message shown to player.
@export var interact_message : String = "Talk"

## Reference to the Area3D child node.
@onready var interaction_area: Area3D = $Area3D
@onready var dialog_handler: Node = $dialogue_handler

var player_in_range : bool = false
var player_ref : Node = null

func _ready() -> void:
	# Add to interactable group so the player can detect us
	add_to_group("interactable")
	add_to_group("npc")
	
	# Connect Area3D signals
	if interaction_area:
		interaction_area.body_entered.connect(_on_body_entered)
		interaction_area.body_exited.connect(_on_body_exited)
	else:
		push_error("NPC requires an Area3D child node named 'Area3D'")


func _on_body_entered(body: Node3D) -> void:
	# Check if it's the player (CharacterBody3D with the player group or specific name)
	if body.is_in_group("player") or body.name == "ProtoController":
		player_in_range = true
		player_ref = body
		player_entered.emit()
		
		# Show interact prompt on the player's UI
		if player_ref.has_method("show_interact_prompt"):
			player_ref.show_interact_prompt()
		
		# Set this NPC as the current interactable
		if player_ref.has_node("Head/InteractionRay"):
			player_ref.current_interactable = self


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") or body.name == "ProtoController":
		player_in_range = false
		player_exited.emit()
		
		# Hide interact prompt on the player's UI
		if player_ref and player_ref.has_method("show_crosshair"):
			player_ref.show_crosshair()
		
		# Clear the current interactable if it was this NPC
		if player_ref and player_ref.get("current_interactable") == self:
			player_ref.current_interactable = null
		
		player_ref = null

## Called when the player interacts with this NPC.
func interact() -> void:
	if player_in_range and player_ref:
		dialog_handler.start_dialogue(dialogue_resource,"greetings")
		
