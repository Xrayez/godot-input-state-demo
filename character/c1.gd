# Typical movement controller
#
# Use cases:
# - control only one character
# - easy to code
#
# Problems:
# - can't be controlled by anything but user input (AI input, recorded input, animated input)
# - affects multiple characters given the same script
#
extends Sprite

var speed = 300.0


func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		position += Vector2.LEFT * speed * delta
	if Input.is_action_pressed("ui_right"):
		position += Vector2.RIGHT * speed * delta
	if Input.is_action_pressed("ui_up"):
		position += Vector2.UP * speed * delta
	if Input.is_action_pressed("ui_down"):
		position += Vector2.DOWN * speed * delta
