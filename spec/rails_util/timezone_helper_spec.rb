require 'spec_helper'

describe RailsUtil::TimezoneHelper do
  let(:from_timezone) { 'America/Chicago' } # currently 5 hours behind UTC
  let(:to_timezone) { 'America/New_York' } # currently 5 hours behind UTC

  let(:time) { Time.new(2000, 1, 1, 7, 30, 0) } # arbitrary date, timezone agnostic time
  let(:date) { Date.new(2017, 9, 27) }

  let(:subject) { RailsUtil::TimezoneHelper }

  describe '#convert_timezone' do
    it 'no date provided' do
      time_with_offset = DateTime.new(2000, 1, 1, 8, 30, 0, '-04:00')
      expect(subject.convert_timezone(time, to_timezone, from_timezone)).to eq(time_with_offset)
    end

    it 'specific date provided' do
      time_with_offset = DateTime.new(2017, 9, 27, 8, 30, 0, '-04:00')
      expect(subject.convert_timezone(time, to_timezone, from_timezone, date: date)).to eq(time_with_offset)
    end
  end

  describe '#convert_to_utc' do
    it 'no date provided' do
      utc_time = DateTime.new(2000, 1, 1, 12, 30, 0, '+00:00')
      expect(subject.send(:convert_to_utc, time, from_timezone)).to eq(utc_time)
    end

    it 'specific date provided' do
      utc_time = DateTime.new(2017, 9, 27, 12, 30, 0, '+00:00')
      expect(subject.send(:convert_to_utc, time, from_timezone, date)).to eq(utc_time)
    end
  end

  describe '#convert_from_utc' do
    it 'no date provided' do
      chicago_time = DateTime.new(2000, 1, 1, 2, 30, 0, '-05:00')
      expect(subject.send(:convert_from_utc, time, from_timezone)).to eq(chicago_time)
    end

    it 'specific date provided' do
      chicago_time = DateTime.new(2017, 9, 27, 2, 30, 0, '-05:00')
      expect(subject.send(:convert_from_utc, time, from_timezone, date)).to eq(chicago_time)
    end
  end

  describe '#timezone_with_offset' do
    it 'no date provided' do
      chicago_time = DateTime.new(2000, 1, 1, 7, 30, 0, '-05:00')
      expect(subject.send(:timezone_with_offset, time, from_timezone)).to eq(chicago_time)
    end

    it 'specific date provided' do
      chicago_time = DateTime.new(2017, 9, 27, 7, 30, 0, '-05:00')
      expect(subject.send(:timezone_with_offset, time, from_timezone, date)).to eq(chicago_time)
    end
  end

  describe '#format_offset' do
    it 'returns formatted string offset' do
      expect(subject.send(:format_offset, from_timezone)).to eq('-05:00')
    end
  end

  describe '#utc_offset' do
    it 'returns FixNum offset' do
      expect(subject.send(:utc_offset, from_timezone)).to eq(-5)
    end
  end
end
