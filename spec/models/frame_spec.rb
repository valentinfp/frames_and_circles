require 'rails_helper'

RSpec.describe Frame, type: :model do
  let(:circle) { instance_double("Circle") }

  before do
    allow(Circle).to receive(:new).and_return(circle)
  end

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
end
