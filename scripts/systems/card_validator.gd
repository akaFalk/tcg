class_name CardValidator extends Node3D

static func validate(card: Card, player: Player) -> bool:
	var conditions = card.card_data.get_play_conditions()
	
	for condition in conditions:
		if not condition.validate(card, player):
			return false
	
	return true
