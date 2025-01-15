extends Node2D
class_name Weapon_Enemy

enum STATES {READY, FIRING, RELOADING}

@onready var BULLET_SCENE = load("res://scenes/enemy_bullet.tscn") as PackedScene
@onready var reload_timer: Timer = $ReloadTimer

var state : STATES = STATES.READY 

func _ready() -> void:
	pass # Replace with function body.
	
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
		bullet.add_to_group('enemy-bullet')	
		#get_parent().add_child(bullet)
		move_to_front()
		get_tree().root.add_child(bullet)
		
	else:
		print("BULLET_SCENE is null! Please set it in the editor.")
		
	change_state(STATES.RELOADING)
	reload_timer.start()
	

func enemy_fire():
	pass
	
func _on_reload_timer_timeout():
	change_state(STATES.READY)
