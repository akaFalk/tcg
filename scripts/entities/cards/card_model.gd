class_name CardModel extends RefCounted

signal card_played

var data: CardData
var logic: CardLogic
var owner: Player

func _init(card_data: CardData, player_ref: Player) -> void:
	data = card_data
	owner = player_ref
	logic = CardLogic.new(self)

func is_playable() -> bool:
	return logic.is_playable
	
func check_playability() -> void:
	logic.check_playability()

func attempt_play() -> bool:
	return logic.attempt_play()
