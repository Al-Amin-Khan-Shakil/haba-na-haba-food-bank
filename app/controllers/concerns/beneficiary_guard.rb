module BeneficiaryGuard
  extend ActiveSupport::Concern

  private

  def redirect_if_beneficiary_exists
    return unless @request

    existing_beneficiary =
      @request.organization_beneficiary ||
      @request.family_beneficiary ||
      @request.individual_beneficiary ||
      @request.inventory

    return unless existing_beneficiary

    redirect_to polymorphic_path(existing_beneficiary),
                notice: "#{existing_beneficiary.class.name.titleize}
                already exists for this request. You cannot create another record on this."
  end
end
