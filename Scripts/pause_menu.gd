extends Control
@onready var optionsMenu = preload("res://Levels/pause_menu.tscn")

func _ready():
	# Hide the pause menu initially
	visible = false

func _input(_event):
	# Handle pause input
	testEsc()

func resume():
	get_tree().paused = false
	visible = false
	# Capture mouse for gameplay
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	visible = true
	# Release mouse for UI interaction
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		print("Is Paused")
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		print("Unpaused")
		resume()


func _on_resume_pressed():
	resume()
	
func _on_main_menu_pressed() -> void:
	get_tree().paused = false  # Unpause before switching scenes
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Show cursor for main menu
	get_tree().change_scene_to_file("res://Levels/main_menu.tscn")
	
func _on_quit_game_pressed() -> void:
	get_tree().paused = false  # Unpause before quitting
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Show cursor before quitting
	get_tree().quit()
