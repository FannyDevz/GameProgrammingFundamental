extends CharacterBody2D

var map_bounds = Rect2(Vector2(0, 0), Vector2(960, 540))
const MENU = preload("res://scenes/menu.tscn")
const SPEED = 64.0
const TURN_SPEED = 2
const ROTATE_SPEED = 20
const NITRO_SPEED = 130
var HEALTH = 10
var HEALTH_NOW = HEALTH
var cooldown: bool = false

signal health_signal(health:int, healthnow:int)
signal death_signal(isTrue:bool)

@onready var weapon: Weapon = $Weapon as Weapon
@onready var nitro: Nitro = $Nitro as Nitro

@onready var body_sprite := $BodySprite
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var demage_flash: AnimationPlayer = $BodySprite/DemageFlash
@onready var cooldown_timer: Timer = $CoolDown
@onready var health_bar: ProgressBar = $"../CanvasLayer/HealthBar"

var direction := Vector2.RIGHT

func _ready() -> void:
	emit_signal("health_signal", HEALTH , HEALTH_NOW)
	health_bar.value = HEALTH_NOW
	#start_cooldown()
	

func _physics_process(delta: float):
	if cooldown:	
		#animation_player.play("cooldown")
		demage_flash.play("flash")
		
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
		#if !cooldown:
			#animation_player.play("Move")	
		velocity = direction.normalized() * input_direction.y * current_speed
		#velocity = lerp(velocity, (direction.normalized() * input_direction.y) * current_speed, current_speed * delta)	
	else :
		velocity = Vector2.ZERO
		nitro.deactive()	
		#if !cooldown:
			#animation_player.play('idle')
	
	move_and_slide()
	global_position.x = clamp(global_position.x, map_bounds.position.x, map_bounds.position.x + map_bounds.size.x)
	global_position.y = clamp(global_position.y, map_bounds.position.y, map_bounds.position.y + map_bounds.size.y)

	var mouse_position = get_global_mouse_position() 
	var direction_to_mouse = (mouse_position - weapon.global_position).normalized() 
	weapon.global_rotation = direction_to_mouse.angle()  

func _input(event):
	if event.is_action_pressed("weapon_fire"):
		weapon.fire()

	if event.is_action_pressed("weapon_rocket"):
		weapon.rocket()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if cooldown:
		return
		
	if area.is_in_group('enemy-bullet'):
		HEALTH_NOW -= area.DAMAGE
		health_bar.value = HEALTH_NOW
		emit_signal("health_signal" , HEALTH , HEALTH_NOW)
		area.queue_free()
		start_cooldown()
	
	if area.is_in_group('enemy-body'):
		HEALTH_NOW -= area.DAMAGE
		health_bar.value = HEALTH_NOW
		area.HEALTH_NOW -= area.DAMAGE
		emit_signal("health_signal" , HEALTH , HEALTH_NOW)
		#area.queue_free()
		start_cooldown()
		
	if HEALTH_NOW <= 0:
		emit_signal("death_signal" ,true)
		get_tree().call_deferred('change_scene_to_packed' , MENU)

func start_cooldown() -> void:
	cooldown = true
	cooldown_timer.start(3)  


func _on_cool_down_timeout() -> void:
	#animation_player.play("idle")	
	cooldown = false
