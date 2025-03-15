class_name ResourceDisplay extends Control

@export var player: Player

func _ready() -> void:
	player.resources_changed.connect(update_display)
	update_display(player.current_resources, player.max_resources)

func update_display(current: int, max_res: int) -> void:
	$Label.text = "Resources: %d/%d" % [current, max_res]
