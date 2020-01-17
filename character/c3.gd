# Controlled (focused) movement
#
# Added `controlled` property.
# Added `ai` property.
#
# Pros:
# - only one "focused" character can be controlled at a time
#
# Problems:
# - in cases where the movement is done by replaying all actions previously recorded,
#   this still creates problem with the global Input handling for multiple characters.
#
extends Sprite

var speed = 300.0
var motion = Vector2()
export var controlled = false
export var human = false


func _physics_process(delta):
	if not controlled:
		return

	if human:
		if Input.is_action_pressed("ui_left"):
			motion += Vector2.LEFT
		if Input.is_action_pressed("ui_right"):
			motion += Vector2.RIGHT
		if Input.is_action_pressed("ui_up"):
			motion += Vector2.UP
		if Input.is_action_pressed("ui_down"):
			motion += Vector2.DOWN
	else:
		# Brownian AI motion!
		motion += [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP][randi() % 4]

	if motion != Vector2():
		position += motion * speed * delta

	motion = Vector2()
