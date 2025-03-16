class_name TurnOwnershipCondition extends PlayCondition

func validate(_model: CardModel) -> bool:
	return GameManager.turn_system.current_player == _model.owner.type

func get_condition_text() -> String:
	return "Can only be played in your turn"
