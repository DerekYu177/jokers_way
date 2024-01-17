# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(JokersWay::Engine::Game) do
  let(:game) { described_class.new }

  describe 'initialize' do
    it 'creates 6 players by default' do
      expect(game.players.count).to(eq(6))
    end

    it 'splits into two random teams' do
      game.teams.each do |team|
        expect(team.count).to(eq(3))
      end
    end

    it 'interleaves the two teams' do
      team1, team2 = game.teams

      expect(game.players).to(eq([team1[0], team2[0], team1[1], team2[1], team1[2], team2[2]]))
    end

    context 'state' do
      it 'has one' do
        expect(game.state).to_not(be_nil)
      end

      it 'contains the teams that have each player id' do
        team1_ids = game.state.offensive[:player_ids]
        team2_ids = game.state.defensive[:player_ids]
        expect([*team1_ids, *team2_ids].sort).to(eq(game.players.map(&:id).sort))
      end
    end

    describe '#turn' do
      context 'when plays a card' do
        it 'plays the card and removes it from the hand of the player' do
          game # initialize
          current_player = game.find_player(game.current_player)
          card_to_play = current_player.cards.first 

          game.turn(id: game.current_player, action: :play, cards: [card_to_play])

          expect(current_player.cards.find(card_to_play)).to(be_nil)
        end
      end

      context 'when finished?' do
        before do
          expect_any_instance_of(JokersWay::Engine::Round).to(receive(:finished?).and_return(true))

          game.round.succeeded = team2
          game.round.jailed = team1
        end

        let(:team1) { game.state.offensive[:player_ids] }
        let(:team2) { game.state.defensive[:player_ids] }

        subject { game.turn(id: 1, action: :play) }

        it 'updates the state with the conclusion' do
          # we expect team2 to gain the initiative
          # as well as get 1 point
          # the first player on team2 will also be the starting_player
          subject
          expect(game.state.defensive).to(include(
            starting_player: nil,
            trump_card_value: 2,
            player_ids: team1,
          ))

          expect(game.state.offensive).to(include(
            starting_player: team2.first,
            trump_card_value: 3,
            player_ids: team2,
          ))
        end
      end
    end
  end
end
