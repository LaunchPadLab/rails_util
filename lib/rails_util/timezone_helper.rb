require 'active_support/time'

module RailsUtil
  # `RailsUtil::TimezoneHelper` contains helper methods for converting a time either to UTC from a given timezone, or to a given timezone from UTC
  module TimezoneHelper
    class << self
      SECONDS_PER_HOUR = 3600

      # Converts a time in a given timezone to UTC
      # @param [String] timezone the ActiveSupport::TimeZone timezone.tzinfo.name
      # @param [Time, DateTime] time can be a Time or DateTime object, will use the date of this argument if date not provided separately
      # @param [Symbol=>[Date]] options the key-value option pairs, used to provide a separate Date object if a specific date is needed, otherwise the date of the time argument is used
      # @return DateTime object with the time in UTC, and a date of either the provided date or time
      def convert_to_utc(timezone, time, **options)
        convert_time_zone(timezone, time, options).utc
      end

      # Converts a time in UTC to the time in the given timezone
      # @param [String] timezone the ActiveSupport::TimeZone timezone.tzinfo.name
      # @param [Time, DateTime] time can be a Time or DateTime object, will use the date of this argument if date not provided separately
      # @param [Symbol=>[Date]] options the key-value option pairs, used to provide a separate Date object if a specific date is needed, otherwise the date of the time argument is used
      # @return DateTime object with the time in the given timezone, and a date of either the provided date or time
      def convert_from_utc(timezone, time, **options)
        time += utc_offset(timezone).hours
        convert_time_zone(timezone, time, options)
      end

      private

      # Creates a DateTime object with the offset of the given timezone, and a time of the time provided
      # @param [String] timezone the ActiveSupport::TimeZone timezone.tzinfo.name
      # @params [Time, DateTime] time can be a Time or DateTime object, will use date of Time object if no date provided
      # @param [Symbol=>[DateTime]] options the key-value option pairs, used to provided a separate DateTime object if a specific date is needed, otherwise the date of the Time object is used
      # @return DateTime object with an offset of the given timezone
      def convert_time_zone(timezone, time, **options)
        date = options.fetch(:date, time)
        DateTime.new(date.year, date.month, date.day, time.hour, time.min, 0, format_offset(timezone))
      end

      # Returns String object representing the UTC offset of the given timezone
      # @param [String] timezone the ActiveSupport::TimeZone timezone.tzinfo.name
      def format_offset(timezone)
        offset = utc_offset(timezone).to_s
        offset.insert(1, '0') if utc_offset(timezone).abs < 10
        offset + ':00'
      end

      # Returns [Fixnum] object representing the UTC offset of the given timezone in hours, taking into account whether Daylight Savings Time is in effect
      # @param [String] timezone the ActiveSupport::TimeZone timezone.tzinfo.name
      def utc_offset(timezone)
        TZInfo::Timezone.get(timezone).current_period.utc_total_offset / SECONDS_PER_HOUR
      end
    end
  end
end
