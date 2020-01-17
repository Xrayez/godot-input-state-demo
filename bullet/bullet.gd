extends Node2D

var speed = 700.0
var direction = Vector2()


func _physics_process(delta):
	if direction == Vector2():
		direction = Vector2.RIGHT
	global_position += direction * speed * delta
