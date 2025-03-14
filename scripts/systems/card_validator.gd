class_name CardValidator extends Node3D

static func validate(card: Card, player_data: PlayerData) -> bool:
	return _check_resources(card, player_data) && _check_phase()

static func _check_resources(card: Card, player_data: PlayerData) -> bool:
	return player_data.current_resources >= card.card_data.cost

static func _check_phase() -> bool:
	return (
		GameManager.turn_system.current_player == PlayerData.Type.PLAYER 
		and GameManager.turn_system.current_phase == TurnSystem.Phase.MAIN
	)
