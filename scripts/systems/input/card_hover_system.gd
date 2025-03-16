class_name CardHoverSystem extends Node3D

@export var drag_and_drop_system: DragAndDropSystem

func on_hovered_over_card(card_view: CardView) -> void:
	if !drag_and_drop_system.dragged_card:
		card_view.animate_hover(true)

func on_hovered_off_card(card_view: CardView) -> void:
	if !drag_and_drop_system.dragged_card:
		card_view.animate_hover(false)

func connect_card_signals(card: Card) -> void:
	card.view.hovered.connect(on_hovered_over_card)
	card.view.hovered_off.connect(on_hovered_off_card)
