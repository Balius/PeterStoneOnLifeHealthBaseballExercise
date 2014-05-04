class BatDetail < ActiveRecord::Base

 attr_accessible :id,:playerID,:yearID,:league,:teamID,
 :games,:bats,:runs,:hits,:doubles,:triples,:homers,:rbi,:sb,:cs

 validates_presence_of :playerID,:yearID,:league,:teamID 

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |bat_detail|
        csv << bat_detail.attributes.values_at(*column_names)
      end
    end
  end

 def self.import(file)
    spreadsheet = open_spreadsheet(file)
 original_header = spreadsheet.row(1)
 header = ["playerID","yearID","league","teamID","games","bats","hits","doubles","triples","homers","rbi","sb","cs"]

  intStartRow = 2
    (intStartRow..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      bat_detail = find_by_id(row["id"]) || new
      bat_detail.attributes = row.to_hash.slice(*accessible_attributes)
    bat_detail.save!
      end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Csv.new(file.path, nil, :ignore)
    when ".xls" then Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.sum_at_bats(i_playerID_str)
   $strSQL = "select sum(bats) as totbats from bat_details where playerID = '#{i_playerID_str}'"
   @count =  BatDetail.find_by_sql($strSQL)
   @count[0]['totbats']
  end

  def self.triple_crown(i_yearID_str, i_league)
# filter 1 = only Batting Details from the correct year and league and those without 400 at bats
# filter 2 = find the player(s) with the MOST homers (we could use rbi or batting average to find the only possible winners)
# filter 3 = check that the player(s) from #3 ALSO had the most RBI and the highest b/a - if not, output "no winner"
    strDesc = "Triple Crown #{i_yearID_str}-#{i_league}"
    $strWhere = "yearID = '#{i_yearID_str}' and league = '#{i_league}' and bats >= 400"

    $strSQL = "select  max(homers) as max_homers, max(rbi) as max_rbi, max(CAST(hits as FLOAT)/bats) as max_bat 
from bat_details where " + $strWhere

    @tcrown_filters=  BatDetail.find_by_sql($strSQL)
    @homers = @tcrown_filters[0]['max_homers']
    @rbi = @tcrown_filters[0]['max_rbi']
    @bat = @tcrown_filters[0]['max_bat']

    $strFilter2 = "homers = #{@homers} and rbi = #{@rbi} and CAST(hits as FLOAT)/bats = #{@bat}"
    $strSQL = "select * from bat_details where " + $strWhere + " and " + $strFilter2
    @mvp_candidates =  BatDetail.find_by_sql($strSQL)
    if @mvp_candidates.count == 0
     "#{strDesc} No Winner"
     else
      "#{strDesc} #{Batter.get_batter_name(@mvp_candidates.first.playerID)}"
     end
     
  end

def batting_average
  if ( (hits.nil? == false) and (bats.nil? == false)  )
    if bats > 0
    (hits / bats.to_f); else; 0;
    end
    else; 0;
   end
end

def singles
  if ( (hits.nil? == false) and (doubles.nil? == false) and (triples.nil? == false) and (homers.nil? == false)  )
    if hits > 0
    (hits  - doubles - triples - homers ); else; 0;
    end
    else; 0;
   end
end

def slugging_average
  if ( (bats.nil? == false) and (hits.nil? == false) and (doubles.nil? == false) and (triples.nil? == false) and (homers.nil? == false)  )
    if bats > 0
    (singles  + doubles * 2 + triples * 3 + homers * 4) / bats.to_f; else; 0;
    end
    else; 0;
   end
	
end


def batter_name
    b = Batter.where(:playerID => playerID).first
    "#{b.nameFirst} #{b.nameLast}"
end

def self.team_slugging(teamID,yearID)
# return the names and slugging averages
  results = []
  team_bats = BatDetail.where(:teamID => teamID, :yearID => yearID)
  team_bats.each do |bat_detail|
  results << [bat_detail.batter_name,bat_detail.slugging_average]
  end
  results
end

def self.most_improved_average(i_yearID)
  $strSQL = "select q2010.playerID as playerID, bat_avg_2010 / bat_avg_2009 as improvement_rto from( select playerID,CAST(hits as FLOAT)/bats as bat_avg_2009 from bat_details WHERE yearID = '#{i_yearID-1}' and bats >= 200) q2010,( select playerID,CAST(hits as FLOAT)/bats as bat_avg_2010 from bat_details WHERE yearID = '#{i_yearID}' and bats >= 200) q2011 where q2010.playerID = q2011.playerID order by improvement_rto desc"
  @bd =  BatDetail.find_by_sql($strSQL)
  if @bd.count > 0 
    "#{ Batter.get_batter_name(@bd.first.playerID)} improved most w/#{(@bd.first.improvement_rto*100).round(2)}% !"
  else
    "Insufficient data"
   end
    
end

end
