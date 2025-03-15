class_name CardData extends Resource

enum Type { CREATURE, SPELL, FIELD }

const TYPE_DISPLAY_STRING: Dictionary = {
	Type.CREATURE: "Creature",
	Type.SPELL: "Spell",
	Type.FIELD: "Field"
}

@export var name: String = ""
@export var cost: int = 0
@export var type: Type
@export var description: String = ""
@export var image: Texture2D = null
@export var play_conditions: Array[PlayCondition] = []

func get_type_as_string() -> String:
	return TYPE_DISPLAY_STRING[type]

func get_play_conditions() -> Array[PlayCondition]:
	# Combine with base conditions if needed
	return play_conditions

func get_condition_texts() -> Array[String]:
	var texts: Array[String] = []
	for c in play_conditions:
		if c:
			var text := c.get_condition_text()
			if text != "":
				texts.append(text)
	return texts
