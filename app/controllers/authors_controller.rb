class BooksController < ApplicationController
  def index
    books = orchestrate_query(Author.all)
    render serialize(books)
  end

  def show
    render serialize(author)
  end

  def create
    if author.save
      render serialize(author).merge(status: :created, location: author)
    else
      unprocessable_entity!(author)
    end
  end

  def update
    if author.update(book_params)
      render serialize(author).merge(status: :ok)
    else
      unprocessable_entity!(author)
    end
  end

  def destroy
    author.destroy
    render status: :no_content
  end

  private

  def author_params
    params.require(:data).permit(:given_name, :family_name)
  end

  def author
    @author ||= params[:id] ? Author.find_by!(id: params[:id]) : Author.new(author_params)
  end
  alias_method :resource, :author
end