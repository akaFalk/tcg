class_name HealthDisplay extends Control

@export var component: HealthComponent

func _ready() -> void:
	component.health_changed.connect(update_display)
	update_display(component.current_health, component.max_health)

func update_display(current: int, max_health: int) -> void:
	$Label.text = "Health: %d/%d" % [current, max_health]
