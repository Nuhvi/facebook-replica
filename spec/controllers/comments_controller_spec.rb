require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }
  before do
     @comment = Comment.new(content: "MyComment")
     @comment.user = user
     @comment.post = post
  end

  describe '#create' do
    context 'as an authenticated user' do
      before { sign_in user }

      context 'with valid attributes' do
        it 'adds a post' do
          expect do
            post :create, params: { comment: { post_id: post.id , content: @comment.content } }
          end.to change(user.comments, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:post_params) { FactoryBot.attributes_for(:post, :invalid) }
        xit 'does not add a project' do
          expect do
            post :create, params: { post: post_params }
          end.not_to change(user.posts, :count)
        end

        xit 'renders new template' do
          post :create, params: { post: post_params }
          expect(response).to render_template(:new)
        end
      end
    end

    context 'as a guest' do
      before { post :create, params: { post: { content: @post.content } } }
      xit 'doesnt respond successfully' do
        expect(response).not_to be_successful
      end

      xit 'redirects to the sign-in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
