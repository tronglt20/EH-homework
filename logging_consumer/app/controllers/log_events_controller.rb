class LogEventsController < ApplicationController
  def index
    @logs = LogEvent.all.limit(10)
  end

  def search
    keyword = params[:keyword]

    if keyword.present?
      @logs = LogEvent.where(message: /#{keyword}/i).desc(:timestamp)
    else
      @logs = LogEvent.all.desc(:timestamp)
    end

    render :index
  end
end
