class LeaguesController < ApplicationController
  include LeaguePermissions

  before_action :require_user_leagues_permission, only: [:new, :create, :destroy]
  before_action :require_user_league_permission, only: [:edit, :update, :visibility]
  before_action :require_league_public_or_permission, only: [:show]
  before_action :require_private, only: [:destroy]

  def index
  end

  def new
    @competition = Competition.new
    @competition.divisions.new
  end

  def create
    @competition = Competition.new(league_params)

    if @competition.save
      redirect_to league_path(@competition)
    else
      render :new
    end
  end

  def show
    @competition = Competition.find(params[:id])
  end

  def edit
    @competition = Competition.find(params[:id])
  end

  def update
    @competition = Competition.find(params[:id])

    if @competition.update(league_params)
      redirect_to league_path(@competition)
    else
      render :edit
    end
  end

  def visibility
    @competition = Competition.find(params[:id])
    @competition.private = league_visibility_params

    if @competition.save
      redirect_to league_path(@competition)
    else
      render :edit
    end
  end

  def destroy
    if Competition.destroy(params[:id])
      redirect_to admin_path(@competition)
    else
      render :edit
    end
  end

  private

  def league_params
    params.require(:competition).permit(:name, :description, :format_id, :signuppable, :roster_lock,
                                        divisions_attributes: [
                                          :id, :name, :description,
                                          :min_teams, :max_teams,
                                          :min_players, :max_players,
                                          :_destroy])
  end

  def league_visibility_params
    params.require(:private)
  end

  def require_private
    @competition = Competition.find(params[:id])
    redirect_to league_path(@competition) unless @competition.private?
  end

  def require_user_leagues_permission
    redirect_to leagues_path unless user_can_edit_leagues?
  end

  def require_user_league_permission
    @competition = Competition.find(params[:id])
    redirect_to league_path(@competition) unless user_can_edit_league?
  end

  def require_league_public_or_permission
    @competition = Competition.find(params[:id])
    redirect_to leagues_path unless @competition.public? || user_can_edit_league?
  end
end
