extends Node

@export var dialogue_resource: DialogueResource

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		DialogueManager.show_dialogue_balloon(dialogue_resource,"start")
