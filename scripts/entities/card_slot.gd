extends Node3D
class_name CardSlot

@export var slot_type: CardData.Type
@export var image: Texture2D

var card_in_slot = false

func _ready() -> void:
	$CardSlotImage.texture = image
	
func accepts_card_type(card: Card) -> bool:
	return slot_type == card.logic.card_data.type and !card_in_slot and card.logic.is_playable

func add_card(card: Card) -> void:
	card.attempt_play()
	card.view.position = position
	card.view.scale = scale
	card.view.set_interactable(false)
	
	card_in_slot = true
