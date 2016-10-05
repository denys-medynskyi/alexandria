# app/presenters/book_presenter.rb
class BookPresenter < BasePresenter
  build_with    :id, :title, :subtitle, :isbn_10, :isbn_13, :description,
                :released_on, :publisher_id, :author_id, :created_at,
                :updated_at, :cover
  related_to :publisher, :author
  sort_by :id, :title
  filter_by :id, :title

  def cover
    @object.cover.url.to_s
  end
end