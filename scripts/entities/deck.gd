class_name Deck extends Node3D

const CARD_Z_OFFSET: float = 0.005

@export var card_loader: CardLoader
@export var player: Player
@export var deck_definition: DeckDefinition

signal card_drawn(card: Card)

var cards: Array[Card]

func initialize_deck() -> void:
	deck_definition.cards.shuffle()
	var total_cards = deck_definition.cards.size()
	var index = 0
	
	for card_data in deck_definition.cards:
		var card: Card = card_loader.create_card(card_data, player)
		player.add_child(card)
		cards.append(card)
		
		var z_position = (total_cards - 1 - index) * CARD_Z_OFFSET
		card.view.position = Vector3(position.x, position.y, position.z + z_position)
		card.view.scale = scale
		index += 1

func draw_card() -> void:
	if cards.is_empty(): return
	
	var drawn_card: Card = cards.pop_front()
	emit_signal("card_drawn", drawn_card)
