extends Node3D
class_name CardSlot

@export var slot_type: CardData.Type
@export var image: Texture2D

var card_in_slot = false

func _ready() -> void:
	$CardSlotImage.texture = image
	
func accepts_card_type(card: Card) -> bool:
	return slot_type == card.card_data.type and !card_in_slot and card.is_playable

func add_card(card: Card) -> void:
	card.attempt_play()
	card.position = position
	card.scale = scale
	
	card_in_slot = true
