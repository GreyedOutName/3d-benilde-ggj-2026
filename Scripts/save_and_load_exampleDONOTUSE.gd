extends Node

func save_game_data(levels_score: Dictionary):
	var file = FileAccess.open("user://save_data.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(levels_score, "\t")) # "\t" for pretty printing
		file.close()
	else:
		print("Error saving file.")

# Loading data
func load_game_data() -> Dictionary:
	var data = {}
	if FileAccess.file_exists("user://save_data.json"):
		var file = FileAccess.open("user://save_data.json", FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var parse_result = JSON.parse_string(json_string)
			if parse_result is Dictionary:
				data = parse_result
			else:
				print("Error parsing JSON data.")
		else:
			print("Error opening file for loading.")
	else:
		print("Save file does not exist.")
	return data

# Delete save file
func delete_save_data():
	if FileAccess.file_exists("user://save_data.json"):
		var err = DirAccess.remove_absolute(ProjectSettings.globalize_path("user://save_data.json"))
		if err == OK:
			print("Save file deleted.")
		else:
			printerr("Error deleting save file: %s" % err)
	else:
		print("No save file to delete.")
