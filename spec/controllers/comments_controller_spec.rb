# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  before { @comment = user.comments.create(FactoryBot.attributes_for(:comment)) }

  describe '#create' do
    context 'as an authenticated user' do
      before { sign_in user }

      context 'with valid attributes' do
        it 'adds a comment' do
          expect do
            post :create, params: { comment: { post_id: @comment.post.id, content: @comment.content } }
          end.to change(user.comments, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:comment_params) { FactoryBot.attributes_for(:comment, :invalid) }
        it 'does not add a project' do
          expect do
            post :create, params: { comment: { post_id: @comment.post.id, content: comment_params } }
          end.not_to change(user.comments, :count)
        end
      end
    end

    context 'as a guest' do
      before { post :create, params: { comment: { post_id: @comment.post.id, content: @comment.content } } }
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
        it 'udpates the comment' do
          patch :update, params: { id: @comment.id, comment: { content: new_content } }
          expect(@comment.reload.content).to eq(new_content)
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: @comment.id, comment: { content: '' } } }
        it 'does not udpate the comment' do
          expect(@comment.reload.content).not_to eq(new_content)
        end

        it 'renders new template' do
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'as an unauthorized user' do
      before { sign_in other_user }

      it 'doesnt udpate the comment' do
        patch :update, params: { id: @comment.id, comment: { content: new_content } }
        expect(@comment.reload.content).not_to eq(new_content)
      end
    end

    context 'as a guest' do
      before { patch :update, params: { id: @comment.id, comment: { content: new_content } } }
      it 'doesnt respond successfully' do
        expect(@comment.reload.content).not_to eq(new_content)
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe '#destroy' do
    context 'as an authenticated user' do
      before { sign_in user }

      it 'delete a comment' do
        expect do
          delete :destroy, params: { id: @comment.id }
        end.to change(user.comments, :count).by(-1)
      end

      it 'deletes all Likes' do
        FactoryBot.create(:like, likeable: @comment, user: user)

        expect do
          delete :destroy, params: { id: @comment.id }
        end.to change(@comment.likes, :count).by(-1)
      end

      it 'redirects to the root url' do
        delete :destroy, params: { id: @comment.id }
        expect(response).to redirect_to root_url
      end
    end

    context 'as an unauthorized user' do
      before { sign_in other_user }

      it "doesn't delete a comment" do
        expect do
          delete :destroy, params: { id: @comment.id }
        end.not_to change(user.comments, :count)
      end
    end

    context 'as a guest' do
      it 'doesnt delete the comment' do
        expect do
          delete :destroy, params: { id: @comment.id }
        end.not_to change(user.comments, :count)
      end
    end
  end
end
