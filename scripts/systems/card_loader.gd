class_name CardLoader extends Node

const CREATURE_CARD_SCENE_PATH = "res://scenes/cards/creature_card.tscn"
const SPELL_CARD_SCENE_PATH = "res://scenes/cards/spell_card.tscn"

func create_card(card_data: CardData, player: Player) -> Card:
	var model = CardModel.new(card_data, player)
	var view_scene = _get_scene_for_type(card_data.type)
	var card = Card.new()
	card.initialize(model, view_scene)
	
	return card
	
func _get_scene_for_type(type: CardData.Type) -> PackedScene:
	var scene_path: String
	match type:
		CardData.Type.CREATURE:
			scene_path = CREATURE_CARD_SCENE_PATH
		CardData.Type.SPELL:
			scene_path = SPELL_CARD_SCENE_PATH
		CardData.Type.FIELD:
			scene_path = "res://cards/field_card.tscn" # TODO
	
	return load(scene_path)
	
