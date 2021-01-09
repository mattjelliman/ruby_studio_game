require_relative '../lib/studio_game/player'
require_relative '../lib/studio_game/die'
require_relative '../lib/studio_game/game_turn'
require_relative '../lib/studio_game/treasure_trove'

module StudioGame
  class Game
    attr_reader :title

    def initialize(title)
      @title = title
      @players = []
    end

    def load_players(filename)
      File.readlines(filename).each do |line|
        name, health = line.split(',')
        player = Player.new(name, Integer(health))
        add_player(player)
      end
    end

    def add_player(player)
      @players << player
    end

    def play(rounds)
      puts "There are #{@players.size} players in #{@title}: "

      treasures = TreasureTrove::TREASURES
      puts "\nThere are #{treasures.size} treasures to be found:"
      treasures.each { |treasure| puts "A #{treasure.name} is worth #{treasure.points} points" }

      @players.each do |player|
        puts player
      end

      1.upto(rounds) do |round|
        puts "\nThis is round #{round}:"
        @players.each do |player|
          GameTurn.take_turn(player)
          puts player
        end
      end
    end

    def print_stats
      strong_players, wimpy_players = @players.partition { |p| p.strong? }

      puts "\n#{@title} Statistics:"

      puts "\n#{strong_players.size} strong player(s):"
      strong_players.each { |p| puts "#{print_name_and_health(p)}" }
      puts "\n#{wimpy_players.size} wimpy player(s):"
      wimpy_players.each { |p| puts "#{print_name_and_health(p)}" }

      puts "\n#{@title} High Scores:"
      @players.sort.each do |player|
        puts high_score_entry(player)
      end

      @players.each do |player|
        puts "\n#{player.name}'s points total:"
        puts "#{player.points} grand total points"
        player.each_found_treasure { |treasure| puts "#{treasure.points} total #{treasure.name} points" }
      end
      puts "\n#{total_points} total points from treasures found."
    end

    def print_name_and_health(player)
      "#{player.name} (#{player.health})"
    end

    def total_points
      @players.reduce(0) { |sum, player| sum + player.points }
    end

    def save_high_scores(filename = 'high_scores.txt')
      File.open(filename, 'w') do |file|
        file.puts "#{@title} High Scores:"
        @players.sort.each do |player|
          file.puts high_score_entry(player)
        end
      end
    end

    def high_score_entry(player)
      "#{player.name.ljust(20, '.')} #{player.score}"
    end
  end
end
