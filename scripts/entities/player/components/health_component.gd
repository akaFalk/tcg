class_name HealthComponent extends Node3D

signal health_changed(new_health: int)

@export var max_health: int = 30
var current_health: int = max_health

func take_damage(amount: int) -> void:
	set_health(current_health - amount)

func heal(amount: int) -> void:
	set_health(current_health + amount)

func set_health(value: int) -> void:
	current_health = clamp(value, 0, max_health)
	health_changed.emit(current_health)
