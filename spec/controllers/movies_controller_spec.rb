require 'spec_helper'

describe MoviesController do

  describe '.create' do
    describe 'with valid params' do
      let(:movie) { stub_model(Movie) }

      it 'should call create!' do
        Movie.should_receive(:create!).and_return(movie)

        post :create
      end
    end
  end

  describe '.similar' do
    let(:movie) { stub_model(Movie) }

    it 'should identify the movie' do
      Movie.should_receive(:find).with("1").and_return(movie)

      get :similar, id: 1
    end

    it 'should get the name of the director' do
      Movie.stub(:find).and_return(movie)
      movie.should_receive(:director)

      get :similar, id: 1
    end

    describe 'search by director' do
      before :each do
        Movie.stub(:find).and_return(movie)
      end

      describe 'there is a director' do
        it 'should search for movies by the same director' do
          movie.stub(:director).and_return("Francis Copola")
          Movie.should_receive(:find_all_by_director).with("Francis Copola")

          get :similar, id: 1
        end

        describe 'render result' do
          before :each do
            movie.stub(:director).and_return("Francis Copola")
            Movie.stub(:find_all_by_director).with("Francis Copola").and_return(["movie1", "movie2"])

            get :similar, id: 1
          end

          it 'should render the similar template' do
            response.should render_template('movies/similar')
          end

          it 'should provide the found movies to the template' do
            assigns(:similar_movies).should == ["movie1", "movie2"]
          end

        end
      end

      describe 'there is no director' do
        before :each do
          movie.stub(:director).and_return(nil)
        end

        it 'should not search for movies by the same director' do
          Movie.should_not_receive(:find_all_by_director)

          get :similar, id: 1
        end

        it 'should redirect to the movies listings' do
          get :similar, id: 1
          response.should redirect_to(movies_path)
        end
      end
    end

  end
end
