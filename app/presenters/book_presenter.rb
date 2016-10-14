# app/presenters/book_presenter.rb
class BookPresenter < BasePresenter
  build_with    :id, :title, :subtitle, :isbn_10, :isbn_13, :description,
                :released_on, :publisher_id, :author_id, :created_at,
                :updated_at, :cover, :price_cents, :price_currency
  related_to :publisher, :author
  sort_by :id, :title
  filter_by :id, :title

  def cover
    path = @object.cover.url.to_s
    path[0] = '' if path[0] == '/'
    "#{root_url}#{path}"
  end
end