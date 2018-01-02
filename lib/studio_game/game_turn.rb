require_relative 'die'
require_relative 'player'

module StudioGame
	module GameTurn
		def self.take_turn(player)
			die = Die.new 
			number_rolled = die.roll
			case die.roll
			when 1..2
				player.blam
			when 3..4
				puts "#{player.name} was skipped."
			else
				player.w00t
			end
			
			treasure = TreasureTrove.random
			player.found_treasure(treasure)
			#puts "#{player.name} found a #{treasure.name} worth #{treasure.points} points."
					
		end
	end
end