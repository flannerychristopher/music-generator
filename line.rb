# frozen_string_literal: true

# behavior of object housing NoteOn and NoteOff events
class Line
  attr_accessor :events

  def initialize
    @events = []
  end
end
