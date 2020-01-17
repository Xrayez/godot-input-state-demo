extends Node2D

# An interface to the recorder

func _on_record_toggled(button_pressed):
	$record.text = "Stop Recording" if button_pressed else "Record"
	$recorder.recording = button_pressed


func _on_play_toggled(button_pressed):
	$play.text = "Stop Playing" if button_pressed else "Play"
	$recorder.playing = button_pressed
