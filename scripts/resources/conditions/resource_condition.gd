class_name ResourceCondition extends PlayCondition


func validate(_card: Card) -> bool:
	return _card.player.can_play_card(_card)

func get_condition_text() -> String:
	return ""
