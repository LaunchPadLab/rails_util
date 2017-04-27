module RailsUtil
  module JsonHelper

    def json_with(resource, **options)
      return json_empty(**options) unless resource
      root_key = options.fetch(:root_key, fetch_key_from_resource(resource))

      return json_error({
        root_key => map_base_to__error(resource.errors.messages)
      }, **options) if has_errors?(resource)

      return json_success({
        root_key => Hash.new
      }, **options) if is_destroyed?(resource)

      render json: resource, **options
    end

    def json_empty(**options)
      render json: {}, **options
    end

    def json_error(nested_path_or_obj, message=nil, **options)
      error_obj = set_nested_path(nested_path_or_obj, message)
      render(
        json: error_obj,
        status: :unprocessable_entity,
        **options
      )
    end

    def json_success(path_or_obj, message=nil, **options)
      render(
        json: set_nested_path(path_or_obj, message),
        **options
      )
    end

    private

    def fetch_key_from_resource(resource)
      return resource.root_key if resource.respond_to?(:root_key)
      resource.class.name.underscore
    end

    def set_nested_path(nested_path_or_obj, message)
      return RailsUtil::Util.set_nested(nested_path_or_obj, message) if nested_path_or_obj.is_a? String
      nested_path_or_obj
    end

    def map_base_to__error(error_obj)
      if error_obj.has_key? :base
        error_obj[:_error] = error_obj.delete(:base)
      end
      error_obj
    end

    def has_errors?(resource)
      resource.respond_to?(:errors) && resource.errors.any?
    end

    def is_destroyed?(resource)
      resource.respond_to?(:destroyed?) && resource.destroyed?
    end
  end
end