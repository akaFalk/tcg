class_name SlotManager extends Node3D

@export var slots: Array[CardSlot]

func has_available_slot(type: CardData.Type) -> bool:
	for slot in slots:
		if slot.slot_type == type and !slot.card_in_slot:
			return true
	return false

func get_available_slot(type: CardData.Type) -> CardSlot:
	for slot in slots:
		if slot.slot_type == type && !slot.card_in_slot:
			return slot
	return null
