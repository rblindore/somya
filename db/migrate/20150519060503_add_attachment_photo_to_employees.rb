class AddAttachmentPhotoToEmployees < ActiveRecord::Migration
  def self.up
    change_table :employees do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :employees, :photo
  end
end
