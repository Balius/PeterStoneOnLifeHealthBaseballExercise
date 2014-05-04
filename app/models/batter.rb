class Batter < ActiveRecord::Base

 attr_accessible :id,:playerID,:birthYear, :nameFirst, :nameLast
 validates_presence_of :playerID,  :nameLast  # lol Barrett barre01 row 659 has no first name?
 
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |batter|
        csv << batter.attributes.values_at(*column_names)
      end
    end
  end

 def self.import(file)
    spreadsheet = open_spreadsheet(file)
 original_header = spreadsheet.row(1)
 header = ["playerID","birthYear","nameFirst","nameLast"]
 
  intStartRow = 2
    (intStartRow..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      batter = find_by_id(row["id"]) || new
      batter.attributes = row.to_hash.slice(*accessible_attributes)
    batter.save!
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

def batter_name
    "#{nameFirst} #{nameLast}"
end

def self.get_batter_name(playerID)
    b = Batter.where(:playerID => playerID).first
    "#{b.nameFirst} #{b.nameLast}"
end

end
