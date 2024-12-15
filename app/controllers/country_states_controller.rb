class CountryStatesController < ApplicationController
  skip_verify_authorized only: %i[index]

  def index
    country = params[:country]
    @target = params[:target]
    @name = params[:name]

    @states = CS[country.to_sym][:states].invert

    respond_to do |format|
      format.turbo_stream
    end
  end
end