import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["donationFields", "requestTypeSelect"];

  connect() {
    this.toggleDonationFields();
  }

  toggleDonationFields() {
    const type = this.requestTypeSelectTarget.value;
    if (type === "donation_request") {
      this.donationFieldsTarget.classList.remove("hidden");
    } else {
      this.donationFieldsTarget.classList.add("hidden");
    }
  }
}
