// app/javascript/controllers/request_form_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["requestTypeSelect", "donationFieldsWrapper"];

  connect() {
    this.toggleDonationFields();
  }

  toggleDonationFields() {
    const type = this.requestTypeSelectTarget.value;

    if (type === "donation_request") {
      this.renderDonationFields();
    } else {
      this.donationFieldsWrapperTarget.innerHTML = "";
    }
  }

  renderDonationFields() {
    this.donationFieldsWrapperTarget.innerHTML = `
      <h3 class="font-bold mt-4">Donation Info</h3>
      <div class="mb-4">
        <label for="request_donation_attributes_donation_type">Donation Type</label>
        <select name="request[donation_attributes][donation_type]" id="request_donation_attributes_donation_type" class="input">
          <option value="">Select a Type</option>
          <option value="fresh_food">Fresh Food</option>
          <option value="non_perishable">Non-perishable</option>
        </select>
      </div>
      <div class="mb-4">
        <label for="request_donation_attributes_donation_name">Donation Name</label>
        <input type="text" name="request[donation_attributes][donation_name]" id="request_donation_attributes_donation_name" class="input" />
      </div>
      <div class="mb-4">
        <label for="request_donation_attributes_amount">Amount</label>
        <input type="number" name="request[donation_attributes][amount]" id="request_donation_attributes_amount" class="input" />
      </div>
    `;
  }
}
