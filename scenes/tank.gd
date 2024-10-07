extends CharacterBody2D

const SPEED = 64.0
const TURN_SPEED = 2
const ROTATE_SPEED = 20
const NITRO_SPEED = 130
#@onready var weapon: Weapon = $Weapon

#@export var weapon: Node2D
@onready var weapon: Weapon = $Weapon as Weapon
@onready var nitro: Nitro = $Nitro as Nitro

@onready var body_sprite := $BodySprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tank_shape: CollisionShape2D = $TankShape

var direction := Vector2.RIGHT

func _physics_process(delta: float):
	var input_direction := Input.get_vector("turn_left", "turn_right", "move_backward", "move_forward")
	if input_direction.x != 0:
		direction = direction.rotated(input_direction.x * (PI / 2) * TURN_SPEED * delta)
		rotation = direction.angle()
	
	var current_speed = SPEED
	if input_direction.y != 0:
		if Input.is_action_pressed("nitro_active"):
			current_speed = NITRO_SPEED
			nitro.active()
		else:
			nitro.deactive()
		animation_player.play("Move")	
		velocity = direction.normalized() * input_direction.y * current_speed
		#velocity = lerp(velocity, (direction.normalized() * input_direction.y) * current_speed, current_speed * delta)	
	else :
		velocity = Vector2.ZERO
		nitro.deactive()
		animation_player.play('idle')
	
	move_and_slide()
	#
	var weapon_rotate_direction := Input.get_axis("rotate_weapon_left","rotate_weapon_right")
	weapon.rotation_degrees += (weapon_rotate_direction * ROTATE_SPEED * delta * PI)

func _input(event):
	if event.is_action_pressed("weapon_fire"):
		weapon.fire()
