extends Area2D

#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite := $Sprite2D
@onready var direction_change_timer: Timer = $Timer2
@onready var weapon: Weapon_Enemy = $Weapon_Enemy as Weapon_Enemy

var player: CharacterBody2D

const SPEED = 34.0
var HEALTH:int = 3
var HEALTH_NOW:int = HEALTH
const POINT = 1 
const DAMAGE = 1

signal enemy_death

var direction: Vector2 = Vector2.ZERO
var initial_movement: bool = true

func _ready() -> void:	
	player = get_tree().get_root().get_node("MainScene/Tank") as CharacterBody2D  # Adjust the path as necessary
	print(player)
	set_direction_to_center()
	direction_change_timer.start()

func point_weapon_to_player() -> void:
	if player:
		var direction_to_player = (player.global_position - weapon.global_position).normalized()
		
		weapon.rotation = direction_to_player.angle()
		
func set_direction_to_center():
	var center_position = get_viewport_rect().size / 2
	direction = (center_position - position).normalized()
	
func _process(delta: float) -> void:
	#animation_player.play('Move')

	position += direction * SPEED * delta
	if direction != Vector2.ZERO: 
		point_weapon_to_player()
		sprite.rotation = direction.angle()
		#weapon.rotation = direction.angle()  # Set weapon rotation to match direction

func set_random_direction():
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()  

func fire():
	weapon.fire()

func _on_timer_timeout() -> void:
	fire()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('tank-bullet'):
		print("damage", area.DAMAGE)
		HEALTH_NOW -= area.DAMAGE
		area.queue_free()
		
	if area.is_in_group('tank-rocket'):
		print("damage", area.DAMAGE)
		HEALTH_NOW -= area.DAMAGE
		area.queue_free()

	if HEALTH_NOW <= 0:
		emit_signal("enemy_death", POINT)
		queue_free()
		

func _on_timer_2_timeout() -> void:
	set_random_direction()
