# frozen_string_literal: true

require 'note'

describe Note do
  let(:params) { { duration: 240, pitch: 120, velocity: 60 } }
  subject { described_class.new(params) }

  it "has a duration" do
    subject.duration.should eq params[:duration]
  end

  it "has a pitch" do
    subject.pitch.should eq params[:pitch]
  end

  it "has a velocity" do
    subject.velocity.should eq params[:velocity]
  end
end