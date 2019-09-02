# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  before { @user = FactoryBot.create(:user) }
  before { @post = FactoryBot.create(:post) }

  describe '#new' do
    context 'as an authenticated user' do
      before { sign_in @user }
      it 'responds successfully' do
        get :new, params: { user_id: @user.id }
        expect(response).to be_successful
      end
    end

    context 'as a guest' do
      it 'doesnt respond successfully' do
        get :new, params: { user_id: @user.id }
        expect(response).not_to be_successful
      end
      it 'redirects to sign in path' do
        get :new, params: { user_id: @user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#show' do
    it 'responds successfully' do
      get :show, params: { user_id: @user.id, id: @post.id }
      expect(response).to be_successful
    end
  end

  describe '#edit' do
    it 'responds successfully' do
      get :edit, params: { user_id: @user.id, id: @post.id }
      expect(response).to be_successful
    end
  end

  describe '#index' do
    it 'responds successfully' do
      get :index, params: { user_id: @user.id }
      expect(response).to be_successful
    end
  end

  describe '#create' do
    context "as an authenticated user" do
      before { sign_in @user }

      context "with valid attributes" do
        it "adds a post" do
          expect {
            post :create, params: { user_id: @user.id, post: { content: @post.content } }
          }.to change(@user.posts, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "does not add a project" do
          post_params = FactoryBot.attributes_for(:post, :invalid)
          expect {
            post :create, params: { user_id: @user.id, post: post_params }
          }.not_to change(@user.posts, :count)
        end

        xit 'renders new template' do
          expect(response).to render_template(:new)
        end
      end
    end

    context "as a guest" do
      it "doesnt respond successfully" do
        post_params = FactoryBot.attributes_for(:post, :invalid)
        post :create, params: { user_id: @user.id, post: post_params }
        expect(response).not_to be_successful
      end

      xit "redirects to the sign-in page" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
