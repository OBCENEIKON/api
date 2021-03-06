module ActiveModelSerializersHelper
  def match_serialized_json(object)
    if object.is_a?(Array)
      expected = serialize_array(object)
    else
      expected = serializer(object).new(object).to_json(root: false)
    end

    eq(expected)
  end

  private

  def serialize_array(array)
    ActiveModel::ArraySerializer.new(
      array,
      each_serializer: serializer(array.first)
    ).to_json(root: false)
  end

  def serializer(object)
    "#{object.class.name}Serializer".constantize
  end
end
