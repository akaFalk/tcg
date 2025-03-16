class_name ResourceCondition extends PlayCondition


func validate(_model: CardModel) -> bool:
	return _model.owner.resource_component.can_afford(_model.data.cost)

func get_condition_text() -> String:
	return ""
