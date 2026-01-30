extends CanvasLayer

@onready var show_button_container:Control = $show_button_container
@onready var evidence_select:Control = $evidence_select
@onready var show_button:Button = $show_button_container/MarginContainer/show_button
@onready var evidence_container:VBoxContainer = $evidence_select/MarginContainer/PanelContainer/evidence_container
var is_evidence_select_up: bool = false

func _ready() -> void:
	GlobalSignals.show_evidence_screen.connect(_show_evidence_screen)
	GlobalSignals.end_dialogue.connect(_end_dialogue)
	show_button_container.visible = false
	evidence_select.visible = false
	update_text()
	
func update_text():
	for child in evidence_container.get_children():
		child.queue_free()
		
	for key in EvidenceManager.Evidences.keys():
		var newText = ""
		var values = EvidenceManager.Evidences[key]
		for value in range(len(values)):
			if EvidenceManager.Evidence_progress[key][value]==1:
				newText+=" "+values[value]
			else:
				newText+=" _____"
			
		var newRichText = RichTextLabel.new()
		newRichText.fit_content = true
		newRichText.bbcode_enabled = true
		newRichText.text = newText
		
		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_top", 8)
		margin.add_theme_constant_override("margin_bottom", 8)
		margin.add_theme_constant_override("margin_left", 12)
		margin.add_theme_constant_override("margin_right", 12)
		margin.add_child(newRichText)
		evidence_container.add_child(margin)

func _show_evidence_screen():
	show_button_container.visible = true

func _end_dialogue():
	show_button_container.visible = false

func _on_show_button_button_up() -> void:
	update_text()
	if !is_evidence_select_up:
		show_button.text = 'Hide Case Files'
		evidence_select.visible = true # Replace with function body.
		is_evidence_select_up = true
	else:
		show_button.text = 'Show Case Files'
		evidence_select.visible = false # Replace with function body.
		is_evidence_select_up = false
