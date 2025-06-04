import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["requestTypeSelect", "donationFieldsWrapper"]

  connect() {
    this.toggleDonationFields()
  }

  toggleDonationFields() {
    const type = this.requestTypeSelectTarget.value
    const wrapper = this.donationFieldsWrapperTarget

    if (type === "donation_request") {
      if (!wrapper.querySelector("select")) {
        this.initializeDonationFields()
      }
    } else {
      wrapper.innerHTML = ""
    }
  }

  initializeDonationFields() {
    this.donationFieldsWrapperTarget.innerHTML = `
      <h3 class="text-xl my-4 font-semibold text-primarytextcolor mb-3 hover:text-gray-900 transition duration-200 underline">
        Donation Information
      </h3>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Donor Type -->
        <div>
          <label for="request_donation_attributes_donor_type" class="block text-gray-700 font-semibold mb-2">
            Donor Type
          </label>
          <select name="request[donation_attributes][donor_type]"
            class="bg-gray-50 border border-gray-300 rounded-lg p-2 w-full focus:outline-none focus:border-primarycolor focus:ring-1 focus:ring-primarycolor">
            <option value="">Select type</option>
            ${Object.entries({
              individual: "Individual",
              private_organization: "Private Organization",
              government_organization: "Government Organization",
              non_government_organization: "Non-Government Organization",
              international_organization: "International Organization",
              others: "Others"
            }).map(([value, label]) => `
              <option value="${value}">${label}</option>
            `).join('')}
          </select>
        </div>

        <!-- Donation Type -->
        <div>
          <label for="request_donation_attributes_donation_type" class="block text-gray-700 font-semibold mb-2">
            Donation Type
          </label>
          <select name="request[donation_attributes][donation_type]"
            class="bg-gray-50 border border-gray-300 rounded-lg p-2 w-full focus:outline-none focus:border-primarycolor focus:ring-1 focus:ring-primarycolor">
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

        <!-- Donation Name -->
        <div>
          <label for="request_donation_attributes_donation_name" class="block text-gray-700 font-semibold mb-2">
            Donation Name
          </label>
          <input type="text" name="request[donation_attributes][donation_name]"
            class="bg-gray-50 border border-gray-300 rounded-lg p-2 w-full focus:outline-none focus:border-primarycolor focus:ring-1 focus:ring-primarycolor" />
        </div>

        <!-- Amount -->
        <div>
          <label for="request_donation_attributes_amount" class="block text-gray-700 font-semibold mb-2">
            Amount
          </label>
          <input type="number" name="request[donation_attributes][amount]" step="0.01"
            class="bg-gray-50 border border-gray-300 rounded-lg p-2 w-full focus:outline-none focus:border-primarycolor focus:ring-1 focus:ring-primarycolor" />
        </div>
      </div>
    `
  }
}
