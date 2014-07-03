class AddSnippetBookmarkletController < ApplicationController

  def index
  end

  def create
    if current_user
      snippet = current_user.snippets.build(snippet_params)
      if snippet.save
        snippet.create_activity :create, owner: current_user, parameters: { snippet_content: snippet.content }

        response = { status: "success", username: current_user.name }
        render json: response.to_json, callback: params['callback']
      else
        response = { status: "fail", error: "Snippet couldn't be saved. Try again later." }
        render json: response.to_json, callback: params['callback']
      end
    else
      response = { status: "fail", error: "Please sign in first" }
      render json: response.to_json, callback: params['callback']
    end
  end

  private

    def snippet_params
      params.require(:snippet).permit(:content, :source)
    end
end
