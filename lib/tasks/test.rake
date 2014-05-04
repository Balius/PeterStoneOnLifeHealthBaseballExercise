task :greet do
puts "PStone 703-476-2121\n"
end

task :results  => :environment do
	puts BatDetail.triple_crown('2012','AL')
end
