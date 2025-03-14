class_name PlayerData extends Resource

enum Type { PLAYER, OPPONENT }

signal resources_changed(current: int, max_resources: int)
signal health_changed(new_health: int)

@export var type: Type

var health: int = 30:
	set(value):
		health = max(0, value)
		health_changed.emit(health)
var current_resources: int = 0
var max_resources: int = 0

func refresh_resources() -> void:
	current_resources = max_resources
	resources_changed.emit(current_resources, max_resources)

func increase_max_resources() -> void:
	max_resources = mini(max_resources + 1, 10)  # Cap at 10
	resources_changed.emit(current_resources, max_resources)

func can_play_card(card: Card) -> bool:
	return can_afford(card.card_data.cost)

func can_afford(cost: int) -> bool:
	return current_resources >= cost

func spend_resources(amount: int) -> void:
	current_resources = max(0, current_resources - amount)
	resources_changed.emit(current_resources, max_resources)
