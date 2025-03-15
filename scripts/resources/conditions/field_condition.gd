class_name FieldCondition extends PlayCondition


func validate(_card: Card) -> bool:
	return _card.player.slot_manager.has_available_slot(_card.card_data.type)

func get_condition_text() -> String:
	return ""
