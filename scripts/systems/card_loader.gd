class_name CardLoader extends Node

const CREATURE_CARD_SCENE_PATH = "res://scenes/cards/creature_card.tscn"
const SPELL_CARD_SCENE_PATH = "res://scenes/cards/spell_card.tscn"

func create_card(card_name: String) -> Card:
	var card_data: CardData = load("res://data/cards/" + card_name.to_snake_case() + ".tres")
	
	var scene_path: String
	match card_data.type:
		CardData.Type.CREATURE:
			scene_path = CREATURE_CARD_SCENE_PATH
		CardData.Type.SPELL:
			scene_path = SPELL_CARD_SCENE_PATH
		CardData.Type.FIELD:
			scene_path = "res://cards/field_card.tscn" # TODO
	
	var card_scene: Resource = load(scene_path)
	var card: Card = card_scene.instantiate()
	card.set_card_data(card_data)
	card.set_labels_visible(false)
	return card
