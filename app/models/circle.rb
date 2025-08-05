class Circle < ApplicationRecord
  belongs_to :frame

  validates :x, :y, numericality: true
  validates :diameter, numericality: { greater_than: 0 }
  validates :x, :y, presence: true
  validates :diameter, presence: true

  validate :within_frame
  validate :no_collision_with_other_circles


  def width_range
    (x - radius)..(x + radius)
  end

  def height_range
    (y - radius)..(y + radius)
  end

  def radius
    diameter / 2.0
  end

  private

  def no_collision_with_other_circles
    return unless valid_for_checks?

    frame.circles.each do |other_circle|
      next if other_circle == self

      if circles_collide?(other_circle)
        errors.add(:base, "Circle collides with another circle in the frame")
      end
    end
  end

  def circles_collide?(other_circle)
    dx = x - other_circle.x
    dy = y - other_circle.y
    distance = Math.sqrt(dx**2 + dy**2)
    distance < (radius + other_circle.radius)
  end

  def within_frame
    return unless valid_for_checks?

    unless frame.within_bounds?(width_range, height_range)
      errors.add(:base, "Circle must be within the frame's bounds")
    end
  end

  def valid_for_checks?
    frame && !frame.circles.empty? && diameter.present? && diameter > 0 && x.present? && y.present?
  end
end
