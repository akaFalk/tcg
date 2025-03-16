class_name TurnOwnershipCondition extends PlayCondition

func validate(_logic: CardLogic) -> bool:
	return GameManager.turn_system.current_player == _logic.player.type

func get_condition_text() -> String:
	return "Can only be played in your turn"
