require 'spec_helper'

describe RailsUtil::TimezoneHelper do
  let(:to_timezone) { 'America/Chicago' } # currently 5 hours behind UTC
  let(:from_timezone) { 'America/New_York' } # currently 4 hours behind UTC
  let(:utc_timezone) { 'Etc/UTC' }


  let(:chicago_offset) { '-05:00' }
  let(:new_york_offset) { '-04:00' }
  let(:utc_offset) { '+00:00' }

  let(:agnostic_time) { Time.new(2000, 1, 1, 7, 30, 33) } # arbitrary date, timezone agnostic time
  let(:specific_time) { DateTime.new(2017, 9, 27, 0, 30, 33, new_york_offset) } # specific datetime object
  let(:utc_time) { DateTime.new(2017, 9, 27, 4, 30, 33, utc_offset) } # specific datetime object
  let(:date) { Date.new(2017, 9, 27) }

  let(:subject) { RailsUtil::TimezoneHelper }

  describe '#convert_timezone' do
    it 'no date provided' do
      time_with_offset = DateTime.new(2017, 9, 26, 23, 30, 33, chicago_offset)
      expect(subject.convert_timezone(specific_time, to_timezone, from_timezone)).to eq(time_with_offset)
    end

    it 'specific date provided' do
      time_with_offset = DateTime.new(2017, 9, 27, 23, 30, 33, chicago_offset)
      expect(subject.convert_timezone(specific_time, to_timezone, from_timezone, date: date)).to eq(time_with_offset)
    end

    it 'after Daylight Savings' do
      specific_time = DateTime.new(2017, 12, 28, 0, 30, 33, '-05:00')
      time_with_offset = DateTime.new(2017, 12, 27, 23, 30, 33, '-06:00')
      allow(subject).to receive(:utc_offset_in_hours).and_return(-6) ## This method changes throughout the year, but the calculation should be applicable
      expect(subject.convert_timezone(specific_time, to_timezone, from_timezone)).to eq(time_with_offset)
    end
  end

  describe '#timezone_difference_in_seconds' do
    it 'positive offset' do
      expect(subject.send(:timezone_difference_in_seconds, from_timezone, to_timezone)).to eq(3600.seconds)
    end

    it 'negative offset' do
      expect(subject.send(:timezone_difference_in_seconds, to_timezone, from_timezone)).to eq(-3600.seconds)
    end
  end

  describe '#timezone_with_offset' do
    it 'no date provided' do
      chicago_time = DateTime.new(2000, 1, 1, 7, 30, 33, chicago_offset)
      expect(subject.send(:timezone_with_offset, agnostic_time, to_timezone, nil)).to eq(chicago_time)
    end

    it 'specific date provided' do
      chicago_time = DateTime.new(2017, 9, 27, 0, 30, 33, chicago_offset)
      expect(subject.send(:timezone_with_offset, specific_time, to_timezone, date)).to eq(chicago_time)
    end
  end

  describe '#format_offset' do
    it 'behind utc' do
      expect(subject.send(:format_offset, to_timezone)).to eq(chicago_offset)
    end

    it 'ahead of utc' do
      expect(subject.send(:format_offset, 'Australia/Melbourne')).to eq('+10:00')
    end
  end

  describe '#utc_offset_in_hours' do
    it 'returns FixNum offset' do
      expect(subject.send(:utc_offset_in_hours, to_timezone)).to eq(-5)
    end
  end
end
