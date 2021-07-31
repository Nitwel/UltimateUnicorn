extends Control

onready var button: Button = $Button
onready var lobbyInput: LineEdit = $LobbyInput

func _ready():
	button.connect("button_down", self, "on_button_click")

func on_button_click():
	print(lobbyInput.text)
	get_tree().change_scene("res://src/Levels/LevelTemplate.tscn")
