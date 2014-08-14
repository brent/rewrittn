class SnippetsController < ApplicationController
  before_action :signed_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def show
    @snippet = @target = Snippet.find_by(id: params[:id])
  end

  def new
    @snippet = Snippet.new
  end

  def create
    @snippet = current_user.snippets.build(snippet_params)
    if @snippet.save
      @snippet.create_activity :create, owner: current_user, parameters: { snippet_content: @snippet.content }
      redirect_to @snippet
    else
      flash[:error] = "Your snippet couldn't be created. Try again?"
      render 'new'
    end
  end

  def destroy
    @snippet.destroy
    redirect_to root_url
  end

  private

    def snippet_params
      params.require(:snippet).permit(:content, :source)
    end

    def correct_user
      @snippet = current_user.snippets.find_by(id: params[:id])
      redirect_to root_url if @snippet.nil?
    end
end
