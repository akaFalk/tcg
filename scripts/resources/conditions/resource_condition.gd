class_name ResourceCondition extends PlayCondition


func validate(_card: Card) -> bool:
	return _card.player.can_afford(_card.card_data.cost)

func get_condition_text() -> String:
	return ""
