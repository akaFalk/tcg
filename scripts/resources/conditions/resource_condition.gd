class_name ResourceCondition extends PlayCondition


func validate(_logic: CardLogic) -> bool:
	return _logic.player.resource_component.can_afford(_logic.card_data.cost)

func get_condition_text() -> String:
	return ""
