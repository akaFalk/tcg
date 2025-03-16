extends Node3D

signal card_view_hovered(card_view: CardView)
signal card_view_hovered_off(card_view: CardView)

var should_hover: bool = true

func _ready():
	card_view_hovered.connect(on_hovered_card_view)
	card_view_hovered_off.connect(on_hovered_off_card_view)

func on_hovered_card_view(card_view: CardView) -> void:
	if should_hover:
		card_view.animate_hover(true)

func on_hovered_off_card_view(card_view: CardView) -> void:
	if should_hover:
		card_view.animate_hover(false)
