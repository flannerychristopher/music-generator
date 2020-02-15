# frozen_string_literal: true

class Note
  attr_accessor :duration, :pitch, :velocity

  def initialize(duration:, pitch:, velocity:)
    @duration = duration
    @pitch = pitch
    @velocity = velocity
  end
end
