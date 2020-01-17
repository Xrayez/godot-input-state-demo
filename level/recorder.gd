extends Node2D

export(NodePath) var target_path
var target = null

var recording = false setget set_recording
var playing = false setget set_playing

var initial_pos = Vector2()
var playback_pos = 0
var snapshots = []


func set_recording(p_enabled):
	recording = p_enabled
	if recording:
		initial_pos = target.global_position
		target.human = true
		snapshots.clear()
		playback_pos = 0


func set_playing(p_enabled):
	playing = p_enabled
	if playing:
		target.global_position = initial_pos
		target.replicated = true
		playback_pos = 0


func _ready():
	target = get_node(target_path)


func _physics_process(_delta):
	# Deferred as we need to ensure that character input is processed first
	# This can also be forced by setting "lower" Node.process_priority,
	# or setting the order of this node to be lower in the scene tree.
	call_deferred("_record")


func _record():
	if recording:
		snapshots.push_back(target.input.data)
	elif playing:
		playback_pos = clamp(playback_pos + 1, 0, snapshots.size() - 1)
		target.input.data = snapshots[playback_pos]
		if playback_pos >= snapshots.size() - 1:
			set_playing(false)
