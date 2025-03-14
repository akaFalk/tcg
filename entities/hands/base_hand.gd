class_name BaseHand extends Node3D

## All hands should implement this signal
signal card_added(card: Card)
signal card_removed(card: Card)

@export var camera: Camera3D
@export var max_cards_visible: int = 10
@export var card_scale: Vector3 = Vector3(0.5, 0.5, 0.5)

var cards: Array[Card] = []
var hand_base_position: Vector3

func _ready() -> void:
	if !camera:
		camera = get_viewport().get_camera_3d()
	get_viewport().connect("size_changed", update_hand_base_position)
	update_hand_base_position()

func update_hand_base_position() -> void:
	## To be implemented in inherited classes
	pass

func add_card(card: Card) -> void:
	cards.append(card)
	card_added.emit(card)
	_configure_card(card)
	update_hand_positions()

func remove_card_from_hand(card: Card) -> void:
	if card in cards:
		cards.erase(card)
		card_removed.emit(card)
		update_hand_positions()

func update_hand_positions() -> void:
	## To be implemented in inherited classes
	pass

func _configure_card(card: Card) -> void:
	## Common card configuration
	card.scale = card_scale
	card.set_labels_visible(true)
