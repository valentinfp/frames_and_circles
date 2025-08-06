require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe "associations" do
    it { should have_many(:circles) }
  end

  describe "validations" do
    it { should validate_presence_of(:width) }
    it { should validate_presence_of(:height) }
    it { should validate_numericality_of(:width).is_greater_than(0) }
    it { should validate_numericality_of(:height).is_greater_than(0) }
    it { should validate_presence_of(:x) }
    it { should validate_presence_of(:y) }
    it { should validate_numericality_of(:x) }
    it { should validate_numericality_of(:y) }

    # Test collision with other frames
    context "when there are overlapping frames" do
      let!(:frame1) { Frame.create!(width: 100, height: 100, x: 50, y: 50) }
      let!(:frame2) { Frame.new(width: 100, height: 100, x: 75, y: 75) }
      it "is not valid" do
        expect(frame2).not_to be_valid
        expect(frame2.errors[:base]).to include("Frame collides with another frame")
      end
    end

    context "when there are no overlapping frames" do
      let!(:frame1) { Frame.create!(width: 100, height: 100, x: 50, y: 50) }
      let!(:frame2) { Frame.new(width: 100, height: 100, x: 200, y: 200) }
      it "is valid" do
        expect(frame2).to be_valid
      end
    end
  end

  describe "instance methods" do
    describe "within_bounds?" do
      let(:frame) { Frame.create!(width: 100, height: 100, x: 50, y: 50) }

      it "returns true if the given ranges are within the frame's bounds" do
        expect(frame.within_bounds?(30..70, 30..70)).to be true
      end

      it "returns false if the given ranges are outside the frame's bounds" do
        expect(frame.within_bounds?(-10..40, -10..40)).to be false
      end
    end

    describe "highest_circle" do
      let(:frame) { Frame.create!(width: 100, height: 100, x: 50, y: 50) }
      let!(:circle1) { Circle.create!(diameter: 20, x: 50, y: 60, frame: frame) }
      let!(:circle2) { Circle.create!(diameter: 20, x: 70, y: 80, frame: frame) }

      it "returns the position of the highest circle" do
        expect(frame.reload.highest_circle).to eq({ x: 70, y: 80 })
      end

      it "returns nil if there are no circles" do
        frame.circles.destroy_all
        expect(frame.highest_circle).to eq({ x: nil, y: nil })
      end
    end

    describe "lowest_circle" do
      let(:frame) { Frame.create!(width: 100, height: 100, x: 50, y: 50) }
      let!(:circle1) { Circle.create!(diameter: 20, x: 50, y: 60, frame: frame) }
      let!(:circle2) { Circle.create!(diameter: 20, x: 70, y: 40, frame: frame) }

      it "returns the position of the lowest circle" do
        expect(frame.reload.lowest_circle).to eq({ x: 70, y: 40 })
      end

      it "returns nil if there are no circles" do
        frame.circles.destroy_all
        expect(frame.lowest_circle).to eq({ x: nil, y: nil })
      end
    end

    describe "leftmost_circle" do
      let(:frame) { Frame.create!(width: 100, height: 100, x: 50, y: 50) }
      let!(:circle1) { Circle.create!(diameter: 20, x: 60, y: 50, frame: frame) }
      let!(:circle2) { Circle.create!(diameter: 20, x: 40, y: 70, frame: frame) }

      it "returns the position of the leftmost circle" do
        expect(frame.reload.leftmost_circle).to eq({ x: 40, y: 70 })
      end

      it "returns nil if there are no circles" do
        frame.circles.destroy_all
        expect(frame.leftmost_circle).to eq({ x: nil, y: nil })
      end
    end
  end
end
