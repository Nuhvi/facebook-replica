# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:post_) { FactoryBot.create(:post) }
  let(:comment) { FactoryBot.create(:comment) }
  let(:like) { FactoryBot.create(:like, user: user) }
  let(:likeable) { like.likeable }
  let(:like_params) { { likeable_id: likeable.id, likeable_type: likeable.class.name } }

  describe '#index' do
    context 'as an authenticated user' do
      before { sign_in user }
      it 'responds successfully' do
        get :index, params: { like: { likeable_id: like.likeable_id, likeable_type: like.likeable_type } }
        expect(response).to be_successful
      end
    end

    context 'as a guest' do
      before { get :index, params: { like: { likeable_id: like.likeable_id, likeable_type: like.likeable_type } } }
      it 'doesnt respond successfully' do
        expect(response).not_to be_successful
      end
      it 'redirects to sign in path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#create' do
    context 'as an authenticated user' do
      before { sign_in user }

      it 'adds a like to post' do
        expect do
          post :create, params: { like: { likeable_id: post_.id, likeable_type: 'Post' } }
        end.to change(post_.likes, :count).by(1)
      end

      it 'adds a like to comment' do
        expect do
          post :create, params: { like: { likeable_id: comment.id, likeable_type: 'Comment' } }
        end.to change(comment.likes, :count).by(1)
      end

      context 'already liked' do
        before { post :create, params: { like: like_params } }
        it "doesn't add like" do
          expect do
            post :create, params: { like: like_params }
          end.not_to change(user.likes, :count)
        end
      end
    end

    context 'as a guest' do
      before { post :create, params: { like: like_params } }
      it 'doesnt respond successfully' do
        expect(response).not_to be_successful
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#destroy' do
    context 'as an authenticated user' do
      before { sign_in user }

      it 'deletes the like' do
        expect do
          delete :destroy, params: { id: like.id }
        end.to change(likeable.likes, :count).by(-1)
      end

      it 'redirects to the root url' do
        delete :destroy, params: { id: like.id }
        expect(response).to redirect_to root_url
      end
    end

    context 'as an unauthorized user' do
      before { sign_in other_user }

      it "doesn't delete the like" do
        expect do
          delete :destroy, params: { id: like.id }
        end.not_to change(likeable.likes, :count)
      end
    end

    context 'as a guest' do
      it 'doesnt delete the like' do
        expect do
          delete :destroy, params: { id: like.id }
        end.not_to change(likeable.likes, :count)
      end
    end
  end
end
