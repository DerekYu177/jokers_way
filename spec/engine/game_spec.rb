# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(JokersWay::Engine::Game) do
  let(:game) { described_class.new }

  describe 'initialize' do
    it 'creates 6 players by default' do
      expect(game.players.count).to(eq(6))
    end

    it 'splits into two random teams' do
      teams = game.players.map { |player| player.team.name }.group_by(&:itself)

      expect(teams.keys.size).to(eq(2))

      teams.each_value do |team|
        expect(team.size).to(eq(3))
      end
    end

    it 'interleaves the two teams' do
      teams = game.players.group_by { |player| player.team.name }

      team1, team2 = teams.values

      expect(game.players).to(eq([team1[0], team2[0], team1[1], team2[1], team1[2], team2[2]]))
    end

    context 'state' do
      it 'has one' do
        expect(game.state).to_not(be_nil)
      end

      it 'contains the teams that have each player id' do
        team1_ids = game.state.starting_player.team.players.map(&:id)
        team2_ids = game.state.starting_player.team.other.players.map(&:id)
        expect([*team1_ids, *team2_ids].sort).to(eq(game.players.map(&:id).sort))
      end
    end

    describe '#turn' do
      context 'when plays a card' do
        it 'plays the card and removes it from the hand of the player' do
          current_player = game.find_player(game.current_player)
          card_to_play = current_player.cards.first

          game.turn(id: game.current_player, action: :play, cards: [card_to_play])

          expect(current_player.cards.find { |card| card == card_to_play }).to(be_nil)
        end
      end

      context 'when finished?' do
        before do
          # team1 has players (1, 2, 3), player (1) escaped, player (2, 3) remaining
          # team2 has players (4, 5, 6), player (4) received the dragon's head. player (5) escaped
          # currently player should be player (3)

          player1, _player2, _player3 = team1.players
          player4, player5, player6 = team2.players

          player1.cards = []
          player4.cards = []
          player5.cards = []

          player6.cards = [player6.cards.first]
          expect(game)
            .to(receive(:current_player).at_least(:once))
            .and_return(player6.id)

          # prefill
          game.round.finished << player4
          game.round.finished << player1
          game.round.finished << player5
        end

        let(:team1) { game.players.first.team }
        let(:team2) { game.players.first.team.other }

        subject do
          current_player = game.find_player(game.current_player)
          card_to_play = current_player.cards.first

          game.turn(
            id: game.current_player,
            action: :play,
            cards: [card_to_play],
          )
        end

        it 'updates the state' do
          subject

          state = game.state

          expect(state.starting_player).to(eq(team2.players.first))
          expect(team2.score).to(eq(2))
          expect(team1.score).to(eq(2))
        end
      end
    end
  end
end
