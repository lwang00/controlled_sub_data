class SubstanceClassificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :vip_only, except: [:index, :show]

  def index
    @classifications = SubstanceClassification.order(name: :asc).all
    @unclassified_count = SubstanceStatute.where(substance_classification_id: nil).size
  end

  def show
    @substance_classification = SubstanceClassification.where(id: params[:id]).first
    if @substance_classification.schedule_level
      @roman_level = ScheduleLevelsController::LEVELS.keys[@substance_classification.schedule_level - 1]
    end
  end

  def edit
    @substance_classification = SubstanceClassification.where(id: params[:id]).first
  end

  def new
    @substance_classification = SubstanceClassification.new(statute_id: params[:statute_id])
  end

  def create
    @substance_classification = SubstanceClassification.new(substance_classification_params)

    if @substance_classification.save
      redirect_to @substance_classification
    else
      render 'new'
    end
  end

  def update
    @substance_classification = SubstanceClassification.where(id: params[:id]).first

    if @substance_classification.update(substance_classification_params)
      redirect_to @substance_classification
    else
      render 'edit'
    end
  end

  def destroy
    @substance_classification = SubstanceClassification.where(id: params[:id]).first

    if @substance_classification.substances.size > 0
      flash.alert = "You can't delete a classification that still has #{@substance_classification.substances.size} substances attached!"
    else
      notice = "Successfully deleted #{@substance_classification.name}"
      @substance_classification.destroy
      flash.notice = notice
    end

    redirect_to substance_classifications_path
  end

  private

  def substance_classification_params
    params.require(:substance_classification).permit([:name, :comment, :statute_id, :schedule_level] + SubstanceClassification.available_flags)
  end
end
