require_relative '../lib/studio_game/player'
require_relative '../lib/studio_game/die'
require_relative '../lib/studio_game/treasure_trove'
require_relative '../lib/studio_game/loaded_die'

module StudioGame
  module GameTurn
    def self.take_turn(player)
      die = Die.new
      case die.roll
      when 5..6
        player.w00t
      when 1..2
        player.blam
      when 3..4
        puts "#{player.name} was skipped."
      end
      treasure = TreasureTrove.random
      player.found_treasure(treasure)
    end
  end
end
