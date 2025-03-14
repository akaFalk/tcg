class_name ResourceDisplay extends Control

@export var player_data: PlayerData

func _ready() -> void:
	player_data.resources_changed.connect(update_display)
	update_display(player_data.current_resources, player_data.max_resources)

func update_display(current: int, max_res: int) -> void:
	$Label.text = "Resources: %d/%d" % [current, max_res]
