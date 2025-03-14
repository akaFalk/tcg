extends Node3D

var player_deck: Deck
var opponent_deck: Deck
var player_hand: PlayerHand
var opponent_hand: OpponentHand
var turn_system: TurnSystem
@onready var player_data: PlayerData = load("res://data/players/player_data.tres")
@onready var opponent_data: PlayerData = load("res://data/players/opponent_data.tres")

func _ready() -> void:
	initialize_vars()
	start_game()
	player_deck.connect("card_drawn", _on_player_deck_card_drawn)
	opponent_deck.connect("card_drawn", _on_opponent_deck_card_drawn)
	turn_system.phase_changed.connect(_on_phase_changed)
	
func initialize_vars() -> void:
	get_tree().get_node_count()
	player_deck = get_node("/root/Main/PlayerField/Deck")
	opponent_deck = get_node("/root/Main/OpponentField/Deck")
	player_hand = get_node("/root/Main/PlayerField/PlayerHand")
	opponent_hand = get_node("/root/Main/OpponentField/OpponentHand")
	turn_system = get_node("/root/Main/Systems/TurnSystem")

func start_game() -> void:
	player_deck.initialize_deck()
	opponent_deck.initialize_deck()
	deal_initial_cards()

func deal_initial_cards() -> void:
	for i in 5:
		await get_tree().create_timer(0.2).timeout
		player_deck.draw_card()
		
	for i in 5:
		await get_tree().create_timer(0.2).timeout
		opponent_deck.draw_card()

func _on_player_deck_card_drawn(card: Card) -> void:
	player_hand.add_card(card)

func _on_opponent_deck_card_drawn(card: Card) -> void:
	opponent_hand.add_card(card)

func _on_phase_changed(new_phase: TurnSystem.Phase) -> void:
	match new_phase:
		TurnSystem.Phase.DRAW:
			_draw_card()
		TurnSystem.Phase.MAIN:
			_enable_player_actions(true)
		TurnSystem.Phase.BATTLE:
			_start_battle_phase()
		_:
			_enable_player_actions(false)
			
func _draw_card() -> void:
	if turn_system.current_player == PlayerData.Type.PLAYER:
		player_deck.draw_card()
	else:
		opponent_deck.draw_card()

func _enable_player_actions(enabled: bool) -> void:
	# Implement UI/input enable/disable
	pass

func _start_battle_phase() -> void:
	# Placeholder for battle logic
	pass
