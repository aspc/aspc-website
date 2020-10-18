require "mini_magick"

class Person < ApplicationRecord
  enum role: [:senator, :staff, :board]
  scope :priority_order, -> {order(priority: :asc)}
  has_one_attached :image

  before_save :resize_image

  def resize_image
    filename = image.filename.to_s
    puts attachment_path = "#{Dir.tmpdir}/#{image.filename}"
    File.open(attachment_path, "wb") do |file|
      file.write(image.download)
      file.close
    end
    image_file = MiniMagick::Image.open(attachment_path)
    byebug

    # scale down image such that max(width, height) <= max_dim, preserving aspect ratio
    max_dim = 1000
    w = image_file.width
    h = image_file.height

    if [w, h].max > max_dim
      ratio = max_dim / [w, h].max.to_f
      w = (w * ratio).round
      h = (h * ratio).round
    end

    image_file.resize "#{w}x#{h}"
    image_file.write attachment_path
    byebug
    image.attach(io: File.open(attachment_path), filename: filename, content_type: "image/jpg")
  end
end
