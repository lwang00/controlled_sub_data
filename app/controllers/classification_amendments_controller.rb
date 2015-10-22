class ClassificationAmendmentsController < SubstanceClassificationsController
  def new
    if params[:parent_id]
      @parent = SubstanceClassification.where(id: params[:parent_id]).first
    end
    @substance_classification = ClassificationAmendment.new(parent_id: params[:parent_id], statute_id: params[:statute_id])
  end

  def edit
    @substance_classification = ClassificationAmendment.where(id: params[:id]).first
    @parent = @substance_classification.substance_classification
  end

  def create
    if substance_classification_params[:parent_id].blank?
      flash.alert = 'No parent classification provided!'
      redirect_to substance_classifications_path
    else
      @substance_classification = ClassificationAmendment.new(substance_classification_params)

      if @substance_classification.save
        redirect_to @substance_classification
      else
        render 'new'
      end
    end
  end

  def substance_classification_params
    params.require(:classification_amendment).permit([:parent_id] + PARAMS + SubstanceClassification.available_flags)
  end
end