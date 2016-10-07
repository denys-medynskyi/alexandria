class AuthorPresenter < BasePresenter
  related_to :books
  build_with    :id, :given_name, :family_name, :created_at, :updated_at
end