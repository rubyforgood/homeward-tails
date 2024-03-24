class StatesController < ApplicationController
  skip_verify_authorized only: %i[index]

  def index
    @target = params[:target]
    @name = params[:name]
    @states = CS.states(params[:country]).invert
  end
end
