class_name SpellCard extends Card

func play() -> void:
	if logic.attempt_play():
		print("Casting Spell: %s" % logic.card_data.name)
		# Spell-specific logic here
