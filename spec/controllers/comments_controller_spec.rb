require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  before do
     @post = FactoryBot.create(:post)
     @comment = Comment.new(content: "MyComment")
     @comment.user = user
     @comment.post = @post
  end

  describe '#create' do
    context 'as an authenticated user' do
      before { sign_in user }

      context 'with valid attributes' do
        it 'adds a post' do
          expect do
            post :create, params: { comment:{ post_id: @post.id , content: @comment.content } }
          end.to change(user.comments, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:comment_params) { FactoryBot.attributes_for(:post, :invalid) }
        it 'does not add a project' do
          expect do
            post :create, params: { comment:{ post_id: @post.id , content: comment_params } }
          end.not_to change(user.comments, :count)
        end

        it 'renders new template' do
          post :create, params: { comment:{ post_id: @post.id , content: comment_params } }
          expect(response).to redirect_to root_url
        end
      end
    end

    context 'as a guest' do
      before { post :create, params: { comment:{ post_id: @post.id , content: @comment.content } } }
      it 'doesnt respond successfully' do
        expect(response).not_to be_successful
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
