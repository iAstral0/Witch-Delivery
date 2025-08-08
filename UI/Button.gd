extends Button

func _on_pressed():
	$Pressed.playing = true


func _on_mouse_entered():
	$Hover.playing = true


func _on_mouse_exited():
	pass # Replace with function body.
