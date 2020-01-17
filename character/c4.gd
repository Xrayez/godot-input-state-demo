# Controlled (focused) movement
#
# Added more properties:
# - sprint (hold Shift)
# - shoot (press Space)
# - ... many others
#
# Problems:
# - we have to copy the internal Input state just to allow
#   us to do the same thing we've done so far with all the properties!
#
# Recap:
# - Ideally, we need to remove Input handling dependency from our character scripts.
#   because we don't want the user input to mess up with AI, recorded, or simulated input.
#   This becomes especially important if we have multiple characters being controlled by
#   either human or AI controllers.
#
extends Sprite

var speed = 300.0
var motion = Vector2()
var sprint = false
var shoot = false
# ... and
# ... much
# ... more

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

		sprint = Input.is_action_pressed("sprint")
		shoot = Input.is_action_just_pressed("shoot")
		# ... and many more!
	else:
		# Brownian AI motion!
		motion += [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP][randi() % 4]
		sprint = true if rand_range(0.0, 1.0) > 0.9 else false
		shoot = true if rand_range(0.0, 1.0) > 0.9 else false

	if motion != Vector2():
		if sprint:
			position += motion * speed * 2.0 * delta
		else:
			position += motion * speed * delta

	if shoot:
		var bullet = preload("res://bullet/bullet.tscn").instance()
		get_tree().get_root().add_child(bullet)
		bullet.global_position = global_position
		bullet.direction = motion

	sprint = false
	shoot = false
	motion = Vector2()
