# frozen_string_literal: true

class Rhythm
  attr_accessor :events
  def initialize(length: 7680)
    # duration_lengths = [
    #   480, 480, # quarter
    #   240, 240, 240,
    #   120, 120, 120, 120, 120, 120,
    #   60, 60, 60, 60
    # ]
    duration_lengths = [240]
    @events = []

    # this is a 'knapsack' efficiency problem
    while length.positive?
      event = duration_lengths.sample
      (length - event).positive? ? @events << event : @events << length
      length -= event
    end
  end
end
