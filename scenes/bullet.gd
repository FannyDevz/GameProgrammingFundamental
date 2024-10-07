extends Area2D

const SPEED = 5000
var direction : Vector2 = Vector2()


func _physics_process(delta: float) -> void:
	position += direction.normalized() * SPEED * delta
