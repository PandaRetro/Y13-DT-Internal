extends Control


# Exit game
func _on_exit_pressed():
	get_tree().quit()


func _on_settings_pressed():
	pass # Replace with function body.


# Load main scene
func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
