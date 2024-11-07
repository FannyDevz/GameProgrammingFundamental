extends Label


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _on_tank_health_signal(health: int, healthnow: int) -> void:
	text = str(healthnow)
