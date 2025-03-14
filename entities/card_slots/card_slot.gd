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
	card.card_image_sprite.modulate = Color.WHITE
	card.update_card_render(0)
	
	# Disable the collision shape for the dropped card.
	var collision_shape: CollisionShape3D = card.get_node("Area3D/CollisionShape3D")
	if collision_shape:
		collision_shape.disabled = true
	
	card_in_slot = true
