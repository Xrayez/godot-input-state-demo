# Impoved movement controller
#
# Added `motion` property.
#
# Pros:
# - the motion is determined by the single 'motion' property which allows
#   to control the character via code alone (AI, simulated motion)
# - the property can be recorded and even animated.
#
# Problems:
# - it's still possible to intefere with the movement by global user Input
#
extends Sprite

var speed = 300.0
export var motion = Vector2()


func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		motion += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		motion += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		motion += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		motion += Vector2.DOWN

	if motion != Vector2():
		position += motion * speed * delta

	motion = Vector2()
