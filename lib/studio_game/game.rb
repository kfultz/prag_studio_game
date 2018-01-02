require_relative 'player'
require_relative 'die'
require_relative 'game_turn'
require_relative 'treasure_trove'

module StudioGame
	class Game
	attr_reader :name

		def initialize(title)
			@title = title.capitalize
			@players = []
		end
		
		def load_players(from_file)
			File.readlines(from_file).each do |line|
				add_player(Player.from_csv(line))
			end
		end
		
		def add_player(a_player)
			@players << a_player
		end
		
		def play(rounds)
						
			puts "There are #{@players.size} players in #{@title}:"
			
			@players.each do |player|
				puts player
			end
			1.upto(rounds) do |round|
				if block_given?
					break if yield
				end
				puts "\nRound #{round}:"
				@players.each do |player|
					GameTurn.take_turn(player)
					puts player
				end
			end
			
			treasures = TreasureTrove::TREASURES
			puts "\nThere are #{treasures.size} treasures to be found:"
			treasures.each do |treasure|
				puts "A #{treasure.name} is worth #{treasure.points} points"
			end
			
		end
		
		def total_points
			@players.reduce(0) {|sum, player| sum + player.points}
		end
		
		def high_score_entry(player)
			formatted_name = player.name.ljust(20, '.')
			"#{formatted_name} #{player.score}"
		end
		
		def print_stats
			strong_players = @players.select { |player| player.strong?}
			wimpy_players = @players.reject { |player| player.strong?}
			
			puts "\n#{@title} Statistics:"
			
			puts "\n#{strong_players.size} Strong Players:"
			strong_players.each do |player|
				puts "#{player.name} (#{player.health})"
			end
			
			puts "\n#{wimpy_players.size} Wimpy Players:"
			wimpy_players.each do |player|
				puts "#{player.name} (#{player.health})"
			end
			
			#sorted_players = @players.sort {|a, b| b.score <=> a.score} #this is for high--> low sorting. low--> high sorting would just be player.score
			puts"\n#{@title} High Scores:"
			@players.sort.each do |player|
				puts high_score_entry(player)
			end
			
			@players.sort.each do |player|
				puts "\n#{player.name}'s point totals:"
				player.each_found_treasure do |treasure|
					puts "#{treasure.points} total #{treasure.name} points"
				end
				puts "#{player.points} grand total points}"
			end
			
			puts "#{total_points} total points from treasures found"
		end
		
		def save_high_scores(to_file="high_scores.txt")
			File.open(to_file, "w") do |file|
				file.puts "#{@title} High Scores:"
				@players.sort.each do |player|
					file.puts high_score_entry(player)
				end
			end
		end
	end
end