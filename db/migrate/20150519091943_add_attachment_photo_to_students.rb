class AddAttachmentPhotoToStudents < ActiveRecord::Migration
  def self.up
    change_table :students do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :students, :photo
  end
end
