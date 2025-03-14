class_name CardValidator extends Node3D

static func validate(card: Card, player_data: PlayerData) -> bool:
	return _check_resources(card, player_data) && _check_phase()

static func _check_resources(card: Card, player_data: PlayerData) -> bool:
	if player_data.current_resources < card.card_data.cost:
		# GameManager.show_error("Not enough resources!")
		return false
	return true

static func _check_phase() -> bool:
	if GameManager.turn_system.current_phase != TurnSystem.Phase.MAIN:
		#GameManager.show_error("Can only play cards during main phase!")
		return false
	return true
