class_name ResourceDisplay extends Control

@export var component: ResourceComponent

func _ready() -> void:
	component.resources_changed.connect(update_display)
	update_display(component.current, component.max_resources)

func update_display(current: int, max_res: int) -> void:
	$Label.text = "Resources: %d/%d" % [current, max_res]
