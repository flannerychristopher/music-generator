# frozen_string_literal: true

require 'midilib/sequence'
require './lib/composer'
require './lib/line'
require './lib/rhythm'
require './lib/tonality'

class Composition
  include MIDI

  def initialize
    @seq = Sequence.new
  end

  private

  def create_track
    track = Track.new(@seq)
    @seq.tracks << track
    track
  end

  def write_midi_file
    file_name = "./midi/#{Time.now}.mid"
    File.open(file_name, 'wb') { |file| @seq.write(file) }
  end
end
