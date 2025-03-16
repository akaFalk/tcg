class_name FieldCondition extends PlayCondition


func validate(_model: CardModel) -> bool:
	return _model.owner.slot_manager.has_available_slot(_model.data.type)

func get_condition_text() -> String:
	return ""
