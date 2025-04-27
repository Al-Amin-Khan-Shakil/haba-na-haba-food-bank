import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "addButton"]

  connect() {
    console.log("Nested form controller connected!") // Verify connection
    this.setupRemoveButtons()
  }

  addAssociation(event) {
    event.preventDefault()
    const timestamp = new Date().getTime()
    const newFields = document.createElement("div")
    newFields.classList.add("nested-fields", "my-4", "p-4", "border")
    newFields.innerHTML = this.getTemplate(timestamp)
    this.containerTarget.appendChild(newFields)
    this.setupRemoveButtons()
  }

  removeAssociation(event) {
    event.preventDefault()
    const wrapper = event.target.closest(".nested-fields")
    const destroyInput = wrapper.querySelector("input[name$='[_destroy]']")

    if (destroyInput) {
      destroyInput.value = "1"
      wrapper.style.display = "none"
    } else {
      wrapper.remove()
    }
  }

  setupRemoveButtons() {
    this.containerTarget.querySelectorAll(".remove-nested").forEach(button => {
      button.addEventListener("click", this.removeAssociation.bind(this))
    })
  }

  getTemplate(timestamp) {
    if (this.element.dataset.association === "counties") {
      return `
        <div class="county-fields">
          <div class="field">
            <label>County Name</label>
            <input type="text" name="district[counties_attributes][${timestamp}][name]">
            <input type="hidden" name="district[counties_attributes][${timestamp}][_destroy]" value="0">
          </div>

          <div class="sub-counties-container" data-controller="nested-form" data-association="sub_counties">
            <div data-nested-form-target="container">
              <!-- Sub-counties will be added here -->
            </div>
            <button type="button" data-action="nested-form#addAssociation" class="add-sub-county">Add Sub-County</button>
          </div>

          <button type="button" class="remove-nested">Remove County</button>
        </div>
      `
    } else {
      return `
        <div class="sub-county-fields">
          <div class="field">
            <label>Sub-County Name</label>
            <input type="text" name="${this.getSubCountyNameAttribute(timestamp)}">
            <input type="hidden" name="${this.getSubCountyDestroyAttribute(timestamp)}" value="0">
          </div>
          <button type="button" class="remove-nested">Remove Sub-County</button>
        </div>
      `
    }
  }

  getSubCountyNameAttribute(timestamp) {
    // Get the county index from parent
    const countyId = this.containerTarget.closest(".county-fields")
      .querySelector("input[name^='district[counties_attributes]']")
      .name.match(/\[(\d+)\]/)[1]

    return `district[counties_attributes][${countyId}][sub_counties_attributes][${timestamp}][name]`
  }

  getSubCountyDestroyAttribute(timestamp) {
    // Similar to above but for destroy attribute
    const countyId = this.containerTarget.closest(".county-fields")
      .querySelector("input[name^='district[counties_attributes]']")
      .name.match(/\[(\d+)\]/)[1]

    return `district[counties_attributes][${countyId}][sub_counties_attributes][${timestamp}][_destroy]`
  }
}