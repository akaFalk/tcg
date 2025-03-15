class_name TurnOwnershipCondition extends PlayCondition

func validate(_card: Card) -> bool:
	return GameManager.turn_system.current_player == _card.player.type

func get_condition_text() -> String:
	return "Can only be played in your turn"
