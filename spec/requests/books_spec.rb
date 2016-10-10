require 'rails_helper'
RSpec.describe 'Books', type: :request do

  include_context 'Skip Auth'

  let(:ruby_microscope) { create(:ruby_microscope) }
  let(:rails_tutorial) { create(:ruby_on_rails_tutorial) }
  let(:agile_web_dev) { create(:agile_web_development) }

  let(:books) { [ruby_microscope, rails_tutorial, agile_web_dev] }

  describe 'GET /api/books' do

    before do
      books
    end

    context "with the 'embed' parameter" do
      before { get '/api/books?embed=author' }
      it 'gets the books with their authors embedded' do
        json_body['data'].each do |book|
          expect(book['author'].keys).to eq(
                                             ['id', 'given_name', 'family_name', 'created_at', 'updated_at']
                                         )
        end
      end
    end

    describe 'sorting' do
      context 'with valid column name "id"' do
        it 'sorts the books by "id desc"' do
          get('/api/books?sort=id&dir=desc')
          expect(json_body['data'].first['id']).to eq agile_web_dev.id
          expect(json_body['data'].last['id']).to eq ruby_microscope.id
        end
      end
    end

    context 'when fields are passed' do
      before do
        get '/api/books?fields=id,title,author_id'
      end

      it 'gets books with only the id, title and author_id keys' do
        json_body['data'].each do |book|
          expect(book.keys).to eq ['id', 'title', 'author_id']
        end
      end
    end

    context 'default behaviour' do
      before do
        get '/api/books'
      end

      it 'receives 200 status' do
        expect(response.status).to eq(200)
      end

      it { expect(json_body['data']).to_not be_nil }

      it { expect(json_body['data'].size).to eq(3) }

      it 'gets books all keys' do
        json_body['data'].each do |book|
          expect(book.keys).to eq BookPresenter.build_attributes.map(&:to_s)
        end
      end
    end
  end

  describe 'GET /api/books/:id' do

    context 'with existing resource' do
      before { get "/api/books/#{rails_tutorial.id}" }

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'receives the "rails_tutorial" book as JSON' do
        expected = { data: BookPresenter.new(rails_tutorial, {}).fields.embeds }
        expect(response.body).to eq(expected.to_json)
      end

      context 'with nonexistent resource' do
        it 'gets HTTP status 404' do
          get '/api/books/2314323'
          expect(response.status).to eq 404
        end
      end

    end
  end

  describe 'POST /api/books' do
    let(:author) { create(:michael_hartl) }
    before { post '/api/books', params: { data: params } }

    context 'with valid params' do
      let(:params) do
        attributes_for(:ruby_on_rails_tutorial, author_id: author.id)
      end

      it 'gets HTTP status 201' do
        expect(response.status).to eq 201
      end

      it 'receives the newly created resource' do
        expect(json_body['data']['title']).to eq 'Ruby on Rails Tutorial'
      end

      it 'adds a record in the database' do
        expect(Book.count).to eq 1
      end

      it 'gets the new resource location in the Location header' do
        expect(response.headers['Location']).to eq(
                                                    "http://www.example.com/api/books/#{Book.first.id}"
                                                )
      end
    end
  end
end