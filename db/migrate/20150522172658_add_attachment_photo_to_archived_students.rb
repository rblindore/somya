class AddAttachmentPhotoToArchivedStudents < ActiveRecord::Migration
  def self.up
    change_table :archived_students do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :archived_students, :photo
  end
end
