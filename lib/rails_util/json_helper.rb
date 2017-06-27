module RailsUtil
  # `RailsUtil::JsonHelper` contains helper methods for rendering JSON API responses
  module JsonHelper
    # @param [Object] resource `ActiveRecord` resource
    # @param [Symbol=>[Integer, String, Array]] options the key-value option pairs
    # @return [Object] json object
    def json_with(resource, **options)
      return json_empty(**options) unless resource
      root_key = resource.class.name.split('::').last.underscore

      return json_error(
        { root_key => map_base_to__error(resource.errors.messages) },
        **options
      ) if has_errors?(resource)

      return json_success(
        { root_key => {} },
        **options
      ) if is_destroyed?(resource)

      serialize_json_resource(resource, **options)
    end

    # Renders empty JSON object, along with any other options
    # @param [Symbol=>[Integer, String, Array]] options the key-value option pairs
    # @return [Object] empty json object
    def json_empty(**options)
      render json: {}, **options
    end

    # Renders JSON error response with `422` status, along with any other options
    # @param [String, Hash] nested_path_or_obj the key-value option pairs
    # @param [String] message the message to include in the error object
    # @param [Symbol=>[Integer, String, Array]] options the key-value option pairs
    # @return [Object] json error object
    def json_error(nested_path_or_obj, message=nil, **options)
      error_obj = set_nested_path(nested_path_or_obj, message)
      render(
        json: { errors: error_obj },
        status: :unprocessable_entity,
        **options
      )
    end

    # Renders JSON success response, along with any other options
    # @param [String,Hash] path_or_obj the key-value option pairs
    # @param [String=nil] message the message to include in the error object
    # @param [Symbol=>[Integer, String, Array]] options the key-value option pairs
    # @return [Object] json success object
    def json_success(path_or_obj, message=nil, **options)
      render(
        json: set_nested_path(path_or_obj, message),
        **options
      )
    end

    # Renders serialized JSON resource
    # @param [Object] resource `ActiveRecord` resource
    # @param [Symbol=>[Integer, String, Array]] options the key-value option pairs
    # @return [Object] json resource object
    def serialize_json_resource(resource, **options)
      res = ActiveModelSerializers::SerializableResource.new(resource, options[:serializer_options] || {})
      serialized_obj = res.serializer_instance.object
      type = options[:resource] || set_serialized_object_type(serialized_obj)

      render json: {
        data: {
          type: type,
          attributes: res.serializer_instance
        }
      }, **options
    end

    private

    def set_nested_path(nested_path_or_obj, message)
      return set_nested(nested_path_or_obj, message) if nested_path_or_obj.is_a? String
      nested_path_or_obj
    end

    def map_base_to__error(error_obj)
      error_obj[:_error] = error_obj.delete(:base) if error_obj.key? :base
      error_obj
    end

    def has_errors?(resource)
      resource.respond_to?(:errors) && resource.errors.any?
    end

    def is_destroyed?(resource)
      resource.respond_to?(:destroyed?) && resource.destroyed?
    end

    def set_nested(path, value, obj={})
      obj.deep_merge(path_to_hash(path, value))
    end

    def set_serialized_object_type(obj)
      return obj.class.to_s.underscore unless obj.is_a?(Array) && obj.count.positive?
      obj.first.class.to_s.underscore.pluralize
    end

    def path_to_hash(path, value)
      parts = (path.is_a?(String) ? path.split('.') : path).reverse
      initial = { parts.shift => value }
      parts.reduce(initial) { |a, e| { e => a } }
    end
  end
end