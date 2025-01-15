extends ProgressBar
@export var tank_instance_path: NodePath  # Path ke Tank, diatur melalui editor

var timer: Timer

func _ready() -> void:
	# Dapatkan instance Tank melalui tank_instance_path
	var tank_instance = get_node(tank_instance_path)

	if tank_instance and tank_instance.has_node("Weapon"):
		var weapon_instance = tank_instance.get_node("Weapon")
		if weapon_instance and weapon_instance.has_node("ReloadRocketTimer"):
			timer = weapon_instance.get_node("ReloadRocketTimer")
			if timer is Timer:
				max_value = timer.wait_time
			else:
				print("ReloadRocketTimer bukan Timer!")
		else:
			print("Weapon atau ReloadRocketTimer tidak ditemukan!")
	else:
		print("Tank tidak ditemukan atau tidak memiliki Weapon!")

func _process(delta: float) -> void:
	if timer:
		value = max_value - timer.time_left
		if value == timer.wait_time:
			value = max_value
