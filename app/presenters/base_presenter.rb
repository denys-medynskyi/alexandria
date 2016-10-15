class BasePresenter
  include Rails.application.routes.url_helpers

  CLASS_ATTRIBUTES = {
      build_with: :build_attributes,
      related_to: :relations,
      sort_by: :sort_attributes,
      filter_by: :filter_attributes
  }

  CLASS_ATTRIBUTES.each { |k, v| instance_variable_set("@#{v}", []) }

  class << self
    attr_accessor *CLASS_ATTRIBUTES.values
    CLASS_ATTRIBUTES.each do |k, v|
      define_method k do |*args|
        instance_variable_set("@#{v}", args.map(&:to_s))
      end
    end

    def cached
      @cached = true
    end

    def cached?
      @cached
    end
  end

  attr_accessor :object, :params, :data

  def initialize(object, params, options = {})
    @object = object
    @params = params
    @options = options
    @data = HashWithIndifferentAccess.new
  end

  def as_json(*)
    @data
  end

  def fields
    field_picker.pick
  end

  def embeds
    embed_picker.embed
  end

  def validated_fields
    @fields_params ||= field_picker.fields.sort.join(',')
  end

  def validated_embeds
    @embed_params ||= embed_picker.embeds.sort.join(',')
  end

  def build(actions)
    actions.each do |action|
      send(action)
    end
    self
  end


  private
  def field_picker
    @field_picker ||= FieldPicker.new(self)
  end
  def embed_picker
    @embed_picker ||= EmbedPicker.new(self)
  end

end
