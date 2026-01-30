extends CanvasLayer

@onready var show_button_container:Control = $show_button_container
@onready var evidence_select:Control = $evidence_select
@onready var show_button:Button = $show_button_container/MarginContainer/show_button

var is_evidence_select_up: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.show_evidence_screen.connect(_show_evidence_screen)
	show_button_container.visible = false
	evidence_select.visible = false

func _show_evidence_screen():
	show_button_container.visible = true
	
func _on_show_button_button_up() -> void:
	if !is_evidence_select_up:
		show_button.text = 'Hide Case Files'
		evidence_select.visible = true # Replace with function body.
		is_evidence_select_up = true
	else:
		show_button.text = 'Show Case Files'
		evidence_select.visible = false # Replace with function body.
		is_evidence_select_up = false
