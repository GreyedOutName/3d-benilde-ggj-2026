extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func evidence_get(evidence_index:int,word_index:int) -> void:
	print("Still works")
	GlobalSignals.emit_signal("show_evidence_screen")
	EvidenceManager.Evidence_progress[evidence_index][word_index]=1
