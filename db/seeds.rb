# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Default frames and circles
frame = Frame.find_or_initialize_by(width: 800, height: 600, x: 0, y: 0)
frame.circles.build(diameter: 50, x: 100, y: 100)
frame.circles.build(diameter: 50, x: -100, y: -100)
frame.circles.build(diameter: 50, x: -200, y: -200)

if frame.new_record? || frame.changed? || frame.circles.any?(&:new_record?)
  if frame.save
    puts "Frame and circles created successfully."
  else
    puts "Error(s) creating frame and circles:"
    puts frame.errors.full_messages
    frame.circles.each_with_index do |circle, idx|
      unless circle.errors.empty?
        puts "Circle #{idx + 1}: #{circle.errors.full_messages.join(', ')}"
      end
    end
  end
end
