# frozen_string_literal: true

require 'tonality'
require 'byebug'

describe Tonality do
  shared_examples 'it returns the expected result' do |message, parameter, expected_result|
    let(:class_instance) { described_class.new(parameter) }

    it 'formats the input' do
      expect(class_instance.send(message)).to eq expected_result
    end
  end

  describe '@scale' do
    context 'the input is integers 0 to 11' do
      parameter = (0..11).to_a
      expected_result = parameter
      it_behaves_like 'it returns the expected result', :scale, parameter, expected_result
    end

    context 'some integers are greater than 11' do
      parameter = [0, 14, 15, 1]
      expected_result = [0, 1, 2, 3]
      it_behaves_like 'it returns the expected result', :scale, parameter, expected_result
    end

    context 'all integers are greater than 11' do
      parameter = [36, 50, 64, 41, 55, 57, 71].shuffle
      expected_result = [0, 2, 4, 5, 7, 9, 11]
      it_behaves_like 'it returns the expected result', :scale, parameter, expected_result
    end

    context 'there are duplicate octaves' do
      parameter = [0, 2, 12, 14, 24, 26, 36, 48, 50]
      expected_result = [0, 2]
      it_behaves_like 'it returns the expected result', :scale, parameter, expected_result
    end
  end

  describe '#pitches' do
    context 'the @scale is only root pitches' do
      parameter = [0]
      expected_result = [0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120]
      it_behaves_like 'it returns the expected result', :pitches, parameter, expected_result
    end

    context 'the @scale is chromatic' do
      parameter = (0..11).to_a
      expected_result = (0..127).to_a
      it_behaves_like 'it returns the expected result', :pitches, parameter, expected_result
    end

    context 'the @scale is major' do
      parameter = [0, 2, 4, 5, 7, 9, 11]
      c_major = [
        0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23, 24, 26, 28, 29, 31, 33, 35, 36, 38, 40, 41, 43, 45, 47, 48,
        50, 52, 53, 55, 57, 59, 60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79, 81, 83, 84, 86, 88, 89, 91, 93, 95, 96,
        98, 100, 101, 103, 105, 107, 108, 110, 112, 113, 115, 117, 119, 120, 122, 124, 125, 127
      ]
      it_behaves_like 'it returns the expected result', :pitches, parameter, c_major

      parameter = [1, 3, 5, 6, 8, 10, 12]
      c_sharp_major = c_major.map { |i| i + 1 }
      c_sharp_major.pop
      c_sharp_major.unshift(0)
      it_behaves_like 'it returns the expected result', :pitches, parameter, c_sharp_major
    end
  end

  describe '#octave_pitches' do
    context 'the @scale is major' do
      let!(:expected_result) { [0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120] }
      let(:scale) { [0, 2, 4, 5, 7, 9, 11] }
      let(:class_instance) { described_class.new(scale) }

      it 'repeats a the 0 pitch' do
        expect(class_instance.octave_pitches(0)).to eq expected_result
      end

      it 'repeats the 120 pitch' do
        expect(class_instance.octave_pitches(120)).to eq expected_result
      end

      it 'repeats a pitch not in the tonality' do
        result = expected_result.map { |i| i + 1 }
        expect(class_instance.octave_pitches(61)).to eq result
        result = expected_result.map { |i| i + 3 }
        expect(class_instance.octave_pitches(63)).to eq result
      end
    end
  end

  describe '#bass_pitches' do
    let(:class_instance) { described_class.new }
    it 'returns a subset of pitches' do
      expect(class_instance.melody_pitches.length).to be < class_instance.pitches.length
    end
  end

  describe '#bass_pitches' do
    let(:class_instance) { described_class.new }
    it 'returns a subset of pitches' do
      expect(class_instance.bass_pitches.length).to be < class_instance.pitches.length
    end
  end
end
