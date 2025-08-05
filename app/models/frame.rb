class Frame < ApplicationRecord
  has_many :circles, dependent: :destroy

  validates :width, :height, numericality: { greater_than: 0 }
  validates :x, :y, numericality: true
  validates :width, :height, presence: true
  validates :x, :y, presence: true

  validate :no_collision_with_other_frames

  def x_0
    x - width / 2
  end

  def x_f
    x + width / 2
  end

  def y_0
    y - height / 2
  end

  def y_f
    y + height / 2
  end

  def width_range
    (x_0)..(x_f)
  end

  def height_range
    (y_0)..(y_f)
  end

  def within_bounds?(x_range, y_range)
    width_range.cover?(x_range) && height_range.cover?(y_range)
  end

  private

  def no_collision_with_other_frames
    Frame.where.not(id: id).each do |other_frame|
      if frames_collide?(other_frame)
        errors.add(:base, "Frame collides with another frame")
      end
    end
  end

  def frames_collide?(other_frame)
    x_overlap = (x_0 < other_frame.x_f) && (x_f > other_frame.x_0)
    y_overlap = (y_0 < other_frame.y_f) && (y_f > other_frame.y_0)
    x_overlap && y_overlap
  end
end
