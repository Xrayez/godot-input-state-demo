# Recording and replicating input states
#
# We see how we can have numerous ways on how we can handle input from various
# external sources, so a new InputController class is created via script.
# Here, it accepts human, AI, or data-driven input handling modes.
# It basically decouples the process of collecting input and processing the actual
# logic depending on what actions are pressed etc.
#
# In the scene you'll see a `recorder` node which will fetch and later playback
# recorded input states each frame represented as snapshots of data (Dictionary).

# Press `Record` and do some stuff with the character. Press again to stop
# the recording, and then press `Play` to replicate all actions from data now.
# Notice that we don't actually record the position of the character each frame,
# we only need to do this once and the following is just simulated input.
#
extends Sprite

export(InputState) var input = InputState.new()
var input_controller = InputController.new()

var speed = 300.0

export var controlled = false setget set_controlled
export var human = false setget set_human
export var replicated = false setget set_replicated


func set_controlled(p_controlled):
	controlled = p_controlled
	input_controller.enabled = controlled


func set_human(p_human):
	human = p_human
	input_controller.type = InputController.Type.HUMAN


func set_replicated(p_replicated):
	replicated = p_replicated
	input_controller.type = InputController.Type.DATA


func _physics_process(delta):
	if not input_controller.enabled:
		return

	# 1. A unified way to collect needed input.
	input_controller.process(input)

	# 2. Process logic from now on.

	# Notice that if you replace `input` state with `Input` singleton,
	# it's going to be just the same API-wise!
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

	if input.is_action_just_released("shoot"):
		var bullet = preload("res://bullet/bullet.tscn").instance()
		get_tree().get_root().add_child(bullet)
		bullet.global_position = global_position
		bullet.direction = motion


class InputController:
	enum Type {
		HUMAN,
		AI,
		DATA
	}
	var enabled = true
	var type = Type.HUMAN

	func process(input: InputState):
		match type:
			Type.HUMAN:
				# Copies the global input state to our local state.
				input.feed(Input.state)
			Type.AI:
				# Can be anything, but hardcoded as an example.
				input.release_pressed_events()
				var m = ["ui_left", "ui_right", "ui_up", "ui_down"][randi() % 4]
				input.action_press(m)
				if rand_range(0.0, 1.0) > 0.5:
					input.action_press("sprint")
				if rand_range(0.0, 1.0) > 0.9:
					input.action_press("shoot")
			Type.DATA:
				# Nothing to do, controlled externally.
				pass
