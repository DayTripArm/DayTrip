module PhotosHelper
  def self.upload_and_save_photos(login,  file_type_int, file_type, files)
    dir_path = File.join("public", "uploads", file_type, login.id.to_s)

    unless File.exists? (dir_path)
      FileUtils::mkdir_p dir_path
    end

    files.each do |file, file_obj|
      name = file_obj.original_filename
      tmp_file = file_obj.tempfile
      dest_path = File.join(dir_path, name)
      photos = login.photos.create!(name: name, file_type: file_type_int)
      tmp_file.close(unlink_now=false)
      FileUtils.move tmp_file.path, dest_path
      `chmod -R 777 "#{dest_path}"`
    end
  end

  # Get full path of photo by name
  def self.get_photo_full_path(name, file_type, login_id)
    dir_path = File.join("public", "uploads", file_type, login_id.to_s)
    dest_path = File.join(dir_path, name)
    return dest_path
  end

  # Remove photo from DB and file system
  def self.remove_photos(login, photo)
    path = self.get_photo_full_path(photo[:name], Photo::FILE_TYPES.key(photo[:file_type]), login.id)
    login.photos.where(id: photo[:id]).delete_all
    FileUtils.rm path
  end
end
