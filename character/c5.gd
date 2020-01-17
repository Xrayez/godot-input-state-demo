# Introducing InputState
#
# This adds a new class which decouples input handling logic from the actual state.
#
# Features:
# - we cannot possibly pollute the global input state unless we explicitly tell so.
# - you can request your local state to be updated from the global input state.
# - removes the need to manually copy the internal Input state to each character instance
#   so that there's no need to redefine local variables for each action.
# - use your usual Input API locally
# - the input state can be shared between instances so that multiple characters
#   can be controlled given the same input
# - you can program AI movement by simulating inputs (action presses etc).
# - multiple series of input states can be serialized, sent over the network, and be saved to disk.
#
extends Sprite

export(InputState) var input = InputState.new()
var speed = 300.0

export var controlled = false
export var human = false


func _physics_process(delta):
	if not controlled:
		return

	if human:
		# We have to update our local input state from the global one,
		# in essence requesting a local copy of the state, forwarding it.
		input.feed(Input.state)
	else:
		# Notice how we can modify the state in a similar fashion to Input API.
		# This doesn't interfere with the rest of the characters so we can safely
		# modify the state the way we want locally.
		input.release_pressed_events()
		var rand_move = ["ui_left", "ui_right", "ui_up", "ui_down"][randi() % 4]
		input.action_press(rand_move)
		if rand_range(0.0, 1.0) > 0.5:
			input.action_press("sprint")
		if rand_range(0.0, 1.0) > 0.9:
			input.action_press("shoot")

	# Regardless of whether it was a human or an AI,
	# we can use the same API to determine the behavior now.
	var motion = Vector2()

	if input.is_action_pressed("ui_left"):
		motion += Vector2.LEFT
	if input.is_action_pressed("ui_right"):
		motion += Vector2.RIGHT
	if input.is_action_pressed("ui_up"):
		motion += Vector2.UP
	if input.is_action_pressed("ui_down"):
		motion += Vector2.DOWN

	if input.is_action_pressed("sprint"):
		position += motion * speed * 2.0 * delta
	else:
		position += motion * speed * delta

	if input.is_action_just_pressed("shoot"):
		var bullet = preload("res://bullet/bullet.tscn").instance()
		get_tree().get_root().add_child(bullet)
		bullet.global_position = global_position
		bullet.direction = motion
