# frozen_string_literal: true

require 'midilib/sequence'
require 'midilib/consts'
include MIDI

# initialize the sequence
seq = Sequence.new

# Create a track to hold the notes. Add it to the sequence.
track = Track.new(seq)
seq.tracks << track

# set the tempo
track.events << Tempo.new(Tempo.bpm_to_mpq(120))

base_pitch = 64

pitch_offsets = [-5, -3, 0, 2, 4, 7, 9, 12, 14, 16]

duration_lengths = [
  480, 480, # quarter
  240, 240, 240,
  120, 120, 120, 120, 120, 120,
  60, 60, 60, 60
]

velocities = (60..95).to_a
# base_velocity = (60..95).to_a.sample # 0-127 is possible

melody = []

phrase_length = 3840 # 4 measures in 4/4
duration_sequence = []
while duration_sequence.sum <= phrase_length
  duration_sequence << duration_lengths.sample
end

duration_sequence.each do |duration_length|
  pitch = base_pitch + pitch_offsets.sample
  velocity = velocities.sample
  melody << NoteOn.new(0, pitch, velocity, 0)
  melody << NoteOff.new(0, pitch, velocity, duration_length)
end

melody.each do |event|
  track.events << event
end

file_name = "midi/#{Time.now}.mid"

File.open(file_name, 'wb') { |file| seq.write(file) }