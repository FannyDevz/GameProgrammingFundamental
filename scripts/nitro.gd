extends Node2D
class_name Nitro
@onready var nitro_animation: AnimationPlayer = $NitroAnimation

func _ready() -> void:
	pass # Replace with function body.

func active():
	nitro_animation.play("active")

func deactive():
	nitro_animation.play("deactive")
