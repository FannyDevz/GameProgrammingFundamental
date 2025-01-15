extends Control

@onready var label:Label = $BoxContainer/VBoxContainer/CenterContainer3/Label


func _ready() -> void:
	label.text = str(SCORE.score)

func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
