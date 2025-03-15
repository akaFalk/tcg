class_name PlayCondition extends Resource

func validate(_card: Card) -> bool:
	push_error("validate() not implemented in base PlayCondition class")
	return false

func get_condition_text() -> String:
	return "Unspecified condition"
