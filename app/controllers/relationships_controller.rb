class RelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    @target = params[:relationship][:followed_type].constantize.find(params[:relationship][:followed_id])
    current_user.star!(@target)
    respond_to do |format|
      format.html { redirect_to @target }
      format.js
    end
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    @target = @relationship.followed_type.constantize.find(@relationship[:followed_id])
    current_user.unstar!(@target)
    respond_to do |format|
      format.html { redirect_to @target }
      format.js
    end
  end
end
