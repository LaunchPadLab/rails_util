module RailsUtil
  # `RailsUtil::Util` includes class helper methods for handling nested hashes
  module Util
    # Deep merges a nested hash given a period-delimited path
    # Does not mutate the original hash
    # @param [String, Array] path the nested keys
    # @param [String, Integer, Array] value the value of nested path key
    # @param [Hash] obj the hash object
    # @return [Hash] the nested hash
    def self.set_nested(path, value, obj={})
      obj.deep_merge(path_to_hash(path, value))
    end

    # Deep merges a nested hash given a period-delimited path
    # Mutates the original hash
    # @param [String, Array] path the nested keys
    # @param [String, Integer, Array] value the value of nested path key
    # @param [Hash] obj the hash object
    # @return [Hash] the nested hash
    def self.set_nested!(path, value, obj={})
      obj.deep_merge!(path_to_hash(path, value))
    end

    # Creates a nested hash given a period-delimited path string
    # @param [String, Array] path the period-delimited nested string keys
    # @param [String, Integer, Array] value the value of nested path key
    # @return [Hash] the nested hash
    def self.path_to_hash(path, value)
      parts = (path.is_a?(String) ? path.split('.') : path).reverse
      initial = { parts.shift => value }
      parts.reduce(initial) { |a, e| { e => a } }
    end
  end
end