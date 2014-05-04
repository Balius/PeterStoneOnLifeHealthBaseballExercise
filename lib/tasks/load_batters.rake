task :load_batters, [:filename]  => :environment do |task, args|

require 'csv'
  if args.filename.nil?
    filename = "doc/Master-small.csv"
  else
    filename =  "#{args.filename}"  # "C:/code/OnLifeHealth/Master-small.csv"
  end
#  spreadsheet = CSV.new(filename)
  header = ["playerID","birthYear","nameFirst","nameLast"]
  intStartRow = 1

  batters_csv = CSV.read(filename, :row_sep => :auto)

#  CSV.foreach(file, headers: true) do |row|
#    batter = BatDetail.find_by_id(row["id"]) || new
#    batter.attributes = row.to_hash.select{ |k,v| allowed_attributes.include? k }
#    batter.save!
#  end

(intStartRow..batters_csv.count - 1).each do |i|
  row = batters_csv[i]
  batter = Batter.new
  if row[0].nil? == false
    batter.playerID = row[0]
    batter.birthYear = row[1]
    batter.nameFirst = row[2]
    batter.nameLast = row[3]
    batter.save!
  end
end


end
