class_name EvidenceHandler extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.evidence_get.connect(_evidence_get)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func evidence_get() -> void:
	print("ITS THAT EASY?")

func _evidence_get():
	print("ITS THAT EASY?")
