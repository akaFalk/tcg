class_name ResourceComponent extends Node3D

signal resources_changed(current: int, max_resources: int)

@export var max_cap: int = 10
var current: int = 0
var max_resources: int = 0

func refresh() -> void:
	current = max_resources
	_emit_change()

func increase_max() -> void:
	max_resources = mini(max_resources + 1, max_cap)
	_emit_change()

func spend(amount: int) -> void:
	current = max(0, current - amount)
	_emit_change()

func can_afford(cost: int) -> bool:
	return current >= cost

func _emit_change() -> void:
	resources_changed.emit(current, max_resources)
