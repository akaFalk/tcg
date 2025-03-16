class_name Player extends Node3D

enum Type { PLAYER, OPPONENT }

@export var health_component: HealthComponent
@export var resource_component: ResourceComponent
@export var slot_manager: SlotManager
@export var type: Type
