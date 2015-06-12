class Movie < ActiveRecord::Base

	searchkick
	
	acts_as_votable
	#has_attached_file :image, :styles => { :medium => "200x300#", :thumb => "100x100>" }
	#validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

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

	has_many :comments, dependent: :destroy
	belongs_to :user

	mount_uploader :image, ImageUploader, mount_on: :image_file_name
end
