class PurchasePresenter < BasePresenter
  build_with :id, :book_id, :user_id, :price_cents, :price_currency
  related_to :user, :book
  sort_by :id, :book_id, :user_id, :price_cents, :price_currency, :status
  filter_by :id, :book_id, :user_id, :price_cents, :price_currency
end