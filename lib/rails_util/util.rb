module RailsUtil
  # Utility functions
  module Util
    def set_nested(path, value, obj={})
      obj.deep_merge(path_to_hash(path, value))
    end

    def set_nested!(path, value, obj={})
      obj.deep_merge!(path_to_hash(path, value))
    end

    def path_to_hash(path, value)
      parts = (path.is_a?(String) ? path.split('.') : path).reverse
      initial = { parts.shift => value }
      parts.reduce(initial) { |a, e| { e => a } }
    end
  end
end