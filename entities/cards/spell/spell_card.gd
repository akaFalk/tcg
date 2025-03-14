class_name SpellCard extends Card

# The spell card class implements spell-specific behavior.
func play() -> void:
	print("Casting Spell: " + card_data.card_name + " with effect: " + card_data.effect)
	# TODO: Insert additional spell-specific logic (e.g., targeting, resolving effects) here.
