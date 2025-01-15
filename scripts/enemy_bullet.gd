extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 1000
const ENEMY_SPEED = 200
const DAMAGE = 1

var direction : Vector2 = Vector2()

func _ready():
	pass
	
func _physics_process(delta: float):
	animation_player.play("fire")
	position += direction.normalized() * ENEMY_SPEED * delta
