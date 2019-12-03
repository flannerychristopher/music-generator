# frozen_string_literal: true

class Rhythm
  attr_accessor :events

  def initialize(length: 7680, durations: [240])
    @events = []

    while length.positive?
      event = durations.sample
      (length - event).positive? ? @events << event : @events << length
      length -= event
    end
  end
end
