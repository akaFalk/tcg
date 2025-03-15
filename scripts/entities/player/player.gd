class_name Player extends Node3D

enum Type { PLAYER, OPPONENT }

@export var health_component: HealthComponent
@export var resource_component: ResourceComponent
@export var slot_manager: SlotManager
@export var type: Type

func _ready():
	EventBus.CARD_PLAYED.connect(_on_card_played)

func _on_card_played(card: Card) -> void:
	if card.player.type == type:
		resource_component.spend(card.card_data.cost)
