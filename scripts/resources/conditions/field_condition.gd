class_name FieldCondition extends PlayCondition


func validate(_logic: CardLogic) -> bool:
	return _logic.player.slot_manager.has_available_slot(_logic.card_data.type)

func get_condition_text() -> String:
	return ""
