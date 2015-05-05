class Movie < ActiveRecord::Base
	def self.import(file)
		CSV.foreach(file.path, headers: true) do |row|
			Movie.create! row.to_hash  
		end
	end

	def self.to_csv
		CSV.generate do |csv|
			csv << column_names
			all.each do |movie|
				csv << movie.attributes.values_at(*column_names)
			end
		end
	end
end