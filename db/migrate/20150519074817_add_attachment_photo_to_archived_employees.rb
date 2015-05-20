class AddAttachmentPhotoToArchivedEmployees < ActiveRecord::Migration
  def self.up
    change_table :archived_employees do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :archived_employees, :photo
  end
end
