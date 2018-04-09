# Avoid nested `data` keys
# Avoid nested `attributes` keys
module Serializable
# top level helpers to flatten JSON API Spec structure
  def serialize_and_flatten(resource, options={})
    hash = serialize_hash(resource)
    flatten_and_nest_data(hash, fetch_nested_option(options))
  end

  def serialize_and_flatten_with_class_name(resource, class_name, options={})
    hash = serializable_hash_with_class_name(resource, class_name, options)
    flatten_and_nest_data(hash, fetch_nested_option(options))
  end

  def serialize_and_flatten_collection(resource, class_name, options={})
    hash = serializable_hash_with_class_name(resource, class_name, options)
    flatten_array_and_nest_data(hash, fetch_nested_option(options))
  end

# meat and potato methods
  def serialize(resource, options={}) 
    "#{resource.class.name}Serializer"
      .constantize.new(resource, options).serialized_json
  end

  def serialize_collection(resource, class_name, options={})
    "#{class_name}Serializer"
      .constantize.new(resource, options).serialized_json
  end

  def serialize_with_class_name(resource, class_name, opqtions={})
    "#{class_name}Serializer"
      .constantize.new(resource, options).serialized_json
  end

  def serialize_hash(resource, options={})
    "#{resource.class.name}Serializer"
      .constantize.new(resource, options).serializable_hash
  end

  def serializable_hash_with_class_name(resource, class_name, options={})
    "#{class_name}Serializer"
      .constantize.new(resource, options).serializable_hash
  end

  def flatten_and_nest_data(hash, nested)
    nest_data?(flatten_hash(expose_data(hash)), nested)
  end

  def flatten_array_and_nest_data(hash, nested)
    nest_data?(flatten_array_of_hashes(expose_data(hash)), nested)
  end

  def fetch_nested_option(options)
    options.fetch(:nested, false)
  end

  def nest_data?(resource, nested)
    unless nested
      nest_resource_under_data_key(resource)
    else
      resource
    end
  end

  def nest_resource_under_data_key(resource)
    hash = new_hash
    hash[:data] = resource
    hash
  end

  def new_hash
    Hash.new(0)
  end

  def user_hash_with_token(user, token)
    hash = serialize_and_flatten_with_class_name(user, 
      user_serializer_class(user))
    hash[:data][:token] = token
    hash
  end

# utilities
  def user_serializer_class(user)
    "#{capitalize_user_role(user)}User"
  end

  def capitalize_user_role(user)
    user.role.capitalize
  end

  def expose_data(hash)
    hash[:data]
  end

  def flatten_array_of_hashes(array)
    array.map do |hash|
      flatten_hash(hash)
    end
  end

  def flatten_hash(hash)
    return unless hash
    hash.each_with_object({}) do |(k, v), h|
      if v.is_a?(Hash) && k == :attributes
        flatten_hash(v).map do |h_k, h_v|
          h["#{h_k}".to_sym] = h_v
        end
      else 
        h[k] = v
      end
    end
  end #end of module
end