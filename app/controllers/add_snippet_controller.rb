class AddSnippetController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:create]

  def index
  end

  def create
    if current_user = User.where(remember_token: User.hash(cookies.permanent[:remember_token])).take
      snippet = current_user.snippets.build(snippet_params)

      snippet.save
      snippet.create_activity :create, owner: current_user, parameters: { snippet_content: snippet.content }
    end
    render nothing: true
  end

  private

    def snippet_params
      params.require(:snippet).permit(:content, :source)
    end
end
