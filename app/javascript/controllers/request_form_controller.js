import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["requestTypeSelect", "donationFieldsWrapper"]

  connect() {
    // Initialize based on current request type
    this.toggleDonationFields()
  }

  toggleDonationFields() {
    const type = this.requestTypeSelectTarget.value
    const wrapper = this.donationFieldsWrapperTarget

    if (type === "donation_request") {
      // Only initialize if not already populated by server
      if (!wrapper.querySelector("select")) {
        this.initializeDonationFields()
      }
    } else {
      wrapper.innerHTML = ""
    }
  }

  initializeDonationFields() {
    this.donationFieldsWrapperTarget.innerHTML = `
      <h3 class="font-bold mt-4">Donation Info</h3>
      <div class="mb-4">
        <label for="request_donation_attributes_donation_type">Donation Type</label>
        <select name="request[donation_attributes][donation_type]" class="input">
          <option value="">Select type</option>
          ${Object.entries({
            fresh_food: "Fresh Food",
            dry_food: "Dry Food",
            cloth: "Cloth",
            money: "Money",
            medicine: "Medicine",
            others: "Others"
          }).map(([value, label]) => `
            <option value="${value}">${label}</option>
          `).join('')}
        </select>
      </div>
      <div class="mb-4">
        <label for="request_donation_attributes_donation_name">Donation Name</label>
        <input type="text" name="request[donation_attributes][donation_name]" class="input" />
      </div>
      <div class="mb-4">
        <label for="request_donation_attributes_amount">Amount</label>
        <input type="number" name="request[donation_attributes][amount]" class="input" step="0.01" />
      </div>
    `
  }
}