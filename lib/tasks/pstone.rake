task :greet do
puts "PStone 703-476-2121\n"
end

task :results  => :environment do
  puts "------------------"	
  puts "| Results for #1 |"
  puts "------------------"	
  puts BatDetail.most_improved_average(2010)

  puts "---------------------------------------"	
  puts "| Results for #2 (names in alpha seq) |"
  puts "---------------------------------------"	
  team_slugging = BatDetail.team_slugging('OAK','2007')
  team_slugging.each do |slugger|
    puts "#{slugger[0]} #{(slugger[1]*100).round(2)}"
  end
  puts "------------------"	
  puts "| Results for #3 |"
  puts "------------------"	
  puts BatDetail.triple_crown('2011','AL')
  puts BatDetail.triple_crown('2011','NL')
  puts BatDetail.triple_crown('2012','AL')
  puts BatDetail.triple_crown('2012','NL')
end
