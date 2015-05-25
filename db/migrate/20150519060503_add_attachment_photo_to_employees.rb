class AddAttachmentPhotoToEmployees < ActiveRecord::Migration
  def self.up
    [:photo_content_type, :photo_file_name, :photo_file_size].each do |column_name|
      remove_column :employees, column_name rescue nil
    end
    change_table :employees do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :employees, :photo
  end
end
