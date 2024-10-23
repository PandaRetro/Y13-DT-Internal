extends Control


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_button_2_pressed():
	pass # Replace with function body.


func _on_button_3_pressed():
	get_tree().quit()
