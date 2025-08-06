require 'rails_helper'

RSpec.describe Circle, type: :model do
  describe "associations" do
    it { should belong_to(:frame) }
  end

  describe "validations" do
    it { should validate_presence_of(:diameter) }
    it { should validate_numericality_of(:diameter).is_greater_than(0) }
    it { should validate_presence_of(:x) }
    it { should validate_presence_of(:y) }
    it { should validate_numericality_of(:x) }
    it { should validate_numericality_of(:y) }

    describe "within frame" do
      let(:frame) { Frame.create!(width: 100, height: 100, x: 50, y: 50) }
      let!(:existing_circle) { Circle.create!(diameter: 20, x: 50, y: 50, frame: frame) }

      context "when circle is within frame bounds" do
        let(:frame) { Frame.create!(width: 100, height: 100, x: 50, y: 50) }
        let(:circle) { Circle.new(diameter: 20, x: 90, y: 90, frame: frame) }

        it "is valid" do
          expect(circle).to be_valid
        end
      end

      context "when circle is outside frame bounds" do
        let(:circle) { Circle.new(diameter: 30, x: 90, y: 90, frame: frame) }

        it "is not valid" do
          expect(circle).not_to be_valid
          expect(circle.errors[:base]).to include("Circle must be within the frame's bounds")
        end
      end

      context "when circle collides with another circle in the frame" do
        let(:new_circle) { Circle.new(diameter: 20, x: 55, y: 55, frame: frame) }

        it "is not valid" do
          expect(new_circle).not_to be_valid
          expect(new_circle.errors[:base]).to include("Circle collides with another circle in the frame")
        end
      end

      context "when circle does not collide with other circles" do
        let(:new_circle) { Circle.new(diameter: 20, x: 80, y: 80, frame: frame) }

        it "is valid" do
          expect(new_circle).to be_valid
        end
      end
    end
  end

  describe "class methods" do
    describe ".within_bounds" do
      let(:frame) { Frame.create!(width: 100, height: 100, x: 50, y: 50) }
      let!(:circle1) { Circle.create!(diameter: 5, x: 60, y: 60, frame: frame) }
      let!(:circle2) { Circle.create!(diameter: 5, x: 80, y: 80, frame: frame) }

      it "returns circles within specified bounds" do
        result = Circle.within_bounds(65, 65, 10)
        expect(result).to include(circle1)
        expect(result).not_to include(circle2)
      end
    end
  end
end
