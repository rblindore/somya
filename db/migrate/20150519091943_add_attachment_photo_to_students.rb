class AddAttachmentPhotoToStudents < ActiveRecord::Migration
  def self.up
    [:photo_content_type, :photo_file_name, :photo_file_size].each do |column_name|
      remove_column :students, column_name rescue nil
    end
    change_table :students do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :students, :photo
  end
end
