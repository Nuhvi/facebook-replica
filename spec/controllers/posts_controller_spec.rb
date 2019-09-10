# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  before { @post = user.posts.create(FactoryBot.attributes_for(:post)) }

  describe '#index' do
    context 'as an authenticated user' do
      before { sign_in user }
      it 'responds successfully' do
        get :index, params: { user_id: user.id }
        expect(response).to be_successful
      end
    end

    context 'as a guest' do
      before { get :index, params: { user_id: user.id } }
      it 'doesnt respond successfully' do
        expect(response).not_to be_successful
      end
      it 'redirects to sign in path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#show' do
    context 'as an authenticated user' do
      before { sign_in user }
      it 'responds successfully' do
        get :show, params: { id: @post.id }
        expect(response).to be_successful
      end
    end

    context 'as a guest' do
      before { get :show, params: { id: @post.id } }
      it 'doesnt respond successfully' do
        expect(response).not_to be_successful
      end
      it 'redirects to sign in path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#new' do
    context 'as an authenticated user' do
      before { sign_in user }
      it 'responds successfully' do
        get :new, params: { user_id: user.id }
        expect(response).to be_successful
      end
    end

    context 'as a guest' do
      before { get :new, params: { user_id: user.id } }
      it 'doesnt respond successfully' do
        expect(response).not_to be_successful
      end
      it 'redirects to sign in path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#edit' do
    context 'as an authenticated user' do
      before { sign_in user }
      it 'responds successfully' do
        get :edit, params: { id: @post.id }
        expect(response).to be_successful
      end
    end

    context 'as an unauthorized user' do
      before { sign_in other_user }
      before { get :edit, params: { id: @post.id } }
      it "doesn't respond successfully" do
        expect(response).not_to be_successful
      end

      it 'redirects to root url' do
        expect(response).to redirect_to root_url
      end
    end

    context 'as a guest' do
      before { get :edit, params: { id: @post.id } }
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

      context 'with valid attributes' do
        it 'adds a post' do
          expect do
            post :create, params: { post: { content: @post.content } }
          end.to change(user.posts, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:post_params) { FactoryBot.attributes_for(:post, :invalid) }
        it 'does not add a project' do
          expect do
            post :create, params: { post: post_params }
          end.not_to change(user.posts, :count)
        end

        it 'renders new template' do
          post :create, params: { post: post_params }
          expect(response).to render_template(:new)
        end
      end
    end

    context 'as an unauthorized user' do
      before { sign_in other_user }

      it "doesn't create a post" do
        expect do
          post :create, params: { post: { content: @post.content } }
        end.not_to change(user.posts, :count)
      end
    end

    context 'as a guest' do
      before { post :create, params: { post: { content: @post.content } } }
      it 'doesnt respond successfully' do
        expect(response).not_to be_successful
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'update' do
    let(:new_content) { 'New content' }
    context 'as an authenticated user' do
      before { sign_in user }

      context 'with valid attributes' do
        it 'udpates the post' do
          patch :update, params: { id: @post.id, post: { content: new_content } }
          expect(@post.reload.content).to eq(new_content)
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: @post.id, post: { content: '' } } }
        it 'does not udpate the post' do
          expect(@post.reload.content).not_to eq(new_content)
        end

        it 'renders new template' do
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'as an unauthorized user' do
      before { sign_in other_user }

      it 'doesnt udpate the post' do
        patch :update, params: { id: @post.id, post: { content: new_content } }
        expect(@post.reload.content).not_to eq(new_content)
      end
    end

    context 'as a guest' do
      before { patch :update, params: { id: @post.id, post: { content: new_content } } }
      it 'doesnt respond successfully' do
        expect(@post.reload.content).not_to eq(new_content)
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#destroy' do
    context 'as an authenticated user' do
      before { sign_in user }

      it 'delete a post' do
        expect do
          delete :destroy, params: { id: @post.id }
        end.to change(user.posts, :count).by(-1)
      end

      it 'deletes all comments' do
        FactoryBot.create(:comment, post: @post, user: @post.user)

        expect do
          delete :destroy, params: { id: @post.id }
        end.to change(@post.comments, :count).by(-1)
      end

      it 'deletes all Likes' do
        FactoryBot.create(:like, likeable: @post, user: @post.user)

        expect do
          delete :destroy, params: { id: @post.id }
        end.to change(@post.likes, :count).by(-1)
      end

      it 'redirects to the root url' do
        delete :destroy, params: { id: @post.id }
        expect(response).to redirect_to root_url
      end
    end

    context 'as an unauthorized user' do
      before { sign_in other_user }

      it "doesn't delete a post" do
        expect do
          delete :destroy, params: { id: @post.id }
        end.not_to change(user.posts, :count)
      end
    end

    context 'as a guest' do
      it 'doesnt delete the post' do
        expect do
          delete :destroy, params: { id: @post.id }
        end.not_to change(user.posts, :count)
      end
    end
  end
end
