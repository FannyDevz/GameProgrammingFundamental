extends Node2D
class_name Weapon

enum STATES {READY, FIRING, RELOADING}

#@export var BULLET_SCENE : PackedScene
@onready var BULLET_SCENE = load("res://scenes/bullet.tscn") as PackedScene
@onready var ROCKET_SCENE = load("res://scenes/rocket.tscn") as PackedScene
@onready var reload_timer: Timer = $ReloadTimer
@onready var reload_timer_rocket: Timer = $ReloadRocketTimer

var state : STATES = STATES.READY 
var state_rocket : STATES = STATES.READY 

func _ready() -> void:
	pass # Replace with function body.

func change_state_rocket(new_state: STATES):
	state_rocket = new_state

func change_state(new_state: STATES):
	state = new_state
	
func fire():
	if state == STATES.FIRING || state == STATES.RELOADING :
		return
		
	change_state(STATES.FIRING)
	if BULLET_SCENE:
		var bullet = BULLET_SCENE.instantiate()
		bullet.direction = Vector2.from_angle(global_rotation)
		bullet.global_position = global_position
		bullet.add_to_group('tank-bullet')	
		#get_parent().add_child(bullet)
		move_to_front()
		get_tree().root.add_child(bullet)
		
	else:
		print("BULLET_SCENE is null! Please set it in the editor.")
		
	change_state(STATES.RELOADING)
	reload_timer.start()

func rocket():
	
	if state_rocket == STATES.FIRING || state_rocket == STATES.RELOADING :
		return
		
	change_state_rocket(STATES.FIRING)
	if ROCKET_SCENE:
		var rocket = ROCKET_SCENE.instantiate()
		rocket.direction = Vector2.from_angle(global_rotation)
		rocket.global_position = global_position
		rocket.add_to_group('tank-rocket')	
		#get_parent().add_child(bullet)
		move_to_front()
		get_tree().root.add_child(rocket)
		
	change_state_rocket(STATES.RELOADING)
	reload_timer_rocket.start()

func enemy_fire():
	pass
	
func _on_reload_timer_timeout():
	change_state(STATES.READY)


func _on_reload_rocket_timer_timeout():
	change_state_rocket(STATES.READY)
