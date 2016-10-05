class Filter

  def initialize(scope, params)
    @scope = scope
    @presenter = "#{@scope.model}Presenter".constantize
    @filters = params['q'] || {}
  end

  def filter
    return @scope unless @filters.any?
    @scope
  end

  private

  def build_filter_scope
    @filters.each do |key, data|
      @scope = send(data[:predicate], data[:column], data[:value])
    end
  end

  def format_filters
    @filters.each_with_object({}) do |(key, value), hash|
      hash[key] = {
          value: value,
          column: key.split('_')[0...-1].join('_'),
          predicate: key.split('_').last
      }
    end
  end
end