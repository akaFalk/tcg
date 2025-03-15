class_name CardHoverSystem extends Node3D

@export var player_hand: PlayerHand
@export var drag_and_drop_system: DragAndDropSystem

func on_hovered_over_card(card: Card) -> void:
	if !drag_and_drop_system.dragged_card and card in player_hand.cards:
		card.on_hover()

func on_hovered_off_card(card: Card) -> void:
	if !drag_and_drop_system.dragged_card and card in player_hand.cards:
		card.on_hover_off()

func connect_card_signals(card: Card) -> void:
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
