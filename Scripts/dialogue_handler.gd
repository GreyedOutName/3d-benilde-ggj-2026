extends Node

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(end_dialogue)

func start_dialogue(dialogue_resource:DialogueResource, title: String ):
	DialogueManager.show_dialogue_balloon(dialogue_resource,title)

func end_dialogue(dialogue_resource:DialogueResource):
	GlobalSignals.emit_signal("end_dialogue")
