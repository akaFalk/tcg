class_name PhaseCondition extends PlayCondition

@export var valid_phases: Array[TurnSystem.Phase] = [TurnSystem.Phase.MAIN]

func validate(_card: Card) -> bool:
	return GameManager.turn_system.current_phase in valid_phases

func get_condition_text() -> String:
	return "Can only be played in %s phase" % " / ".join(valid_phases.map(func(p): return TurnSystem.Phase.keys()[p]))
