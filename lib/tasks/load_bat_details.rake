task :load_bat_details, [:filename]   => :environment do |task, args|

require 'csv'

  if args.filename.nil?
    filename = "doc/Batting-07-12.csv"
  else
    filename =  "#{args.filename}"  # "C:/code/OnLifeHealth/Master-small.csv"
  end

  filename = "C:/code/OnLifeHealth/Batting-07-12.csv"
#  spreadsheet = CSV.new(filename)
  header = ["playerID","yearID","league","teamID","games","bats","hits","doubles","triples","homers","rbi","sb","cs"]
  intStartRow = 1

  bat_details_csv = CSV.read(filename, :row_sep => :auto)

(intStartRow..bat_details_csv.count - 1).each do |i|
  row = bat_details_csv[i]
  bat_detail = BatDetail.new
  bat_detail.playerID = row[0]
  bat_detail.yearID = row[1]
  bat_detail.league = row[2]
  bat_detail.teamID = row[3]
  bat_detail.games = row[4] 
  bat_detail.bats = row[5]
  bat_detail.runs = row[6]
  bat_detail.hits = row[7]
  bat_detail.doubles = row[8]
  bat_detail.triples = row[9]
  bat_detail.homers = row[10]
  bat_detail.rbi = row[11]
  bat_detail.sb = row[12]
  bat_detail.cs = row[13]
  bat_detail.save!
end

end
