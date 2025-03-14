extends Node
class_name Stack

# The stack holds actions (cards or abilities) to resolve.
var action_stack: Array = []

# Push an action onto the stack.
func push(action: Object) -> void:
	action_stack.append(action)
	print("Action added to stack: " + action.card_data.card_name)
	# Optionally, update the UI to reflect the new stack state.

# Resolve the top action from the stack.
func resolve() -> void:
	if action_stack.size() > 0:
		var action = action_stack.pop_back()
		print("Resolving action: " + action.card_data.card_name)
		action.play()  # Execute the card or ability’s play method.
	else:
		print("Stack is empty.")
