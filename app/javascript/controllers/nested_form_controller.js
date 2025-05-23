import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "addButton"]

  connect() {
    console.log("Nested form controller connected!")
    this.setupRemoveButtons()
  }

  addAssociation(event) {
    event.preventDefault()
    const timestamp = new Date().getTime()
    const newFields = document.createElement("div")
    newFields.classList.add("nested-fields", "my-4", "border", "border-gray-300", "rounded-lg", "bg-gray-50", "space-y-4")
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
      button.removeEventListener("click", this.removeAssociation.bind(this))
      button.addEventListener("click", this.removeAssociation.bind(this))
    })
  }

  getTemplate(timestamp) {
    if (this.element.dataset.association === "counties") {
      return `
        <div class="county-fields p-3 space-y-4">
          <div class="field">
            <div class="flex justify-between items-center">
              <label class="block text-gray-700 font-medium mb-1">County Name</label>
              <button type="button" class="remove-nested text-gray-600 hover:text-gray-800 transition">
                <i class="fa-solid fa-xmark text-lg"></i>
              </button>
            </div>        
            <input placeholder="County Name" type="text" name="district[counties_attributes][${timestamp}][name]" class="w-full bg-white border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-primarycolor">
            <input type="hidden" name="district[counties_attributes][${timestamp}][_destroy]" value="0">
          </div>

          <div class="sub-counties-container " data-controller="nested-form" data-association="sub_counties">
            <div class="flex justify-end items-center mb-2">
              <button type="button" data-action="nested-form#addAssociation" class="text-left text-sm bg-primarycolor hover:bg-primarycolor/90 text-white py-1 px-3 rounded transition">
                <i class="fa-solid fa-plus "></i> <span class="ml-1 hidden md:inline-block">Add Sub-County</span>
              </button>
            </div>
            <div data-nested-form-target="container" class="space-y-3">
              <!-- Sub-counties will be added here -->
            </div>
          </div>
        </div>
      `
    } else {
      return `
        
          <div class="sub-county-fields field bg-white p-3 rounded-lg">
            <label class="block text-gray-700 font-bold text-sm font-medium mb-1">Sub-County Name</label>
            <input type="text" name="${this.getSubCountyNameAttribute(timestamp)}" class="w-full bg-gray-50 border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-primarycolor">
            <input type="hidden" name="${this.getSubCountyDestroyAttribute(timestamp)}" value="0">
            <button type="button" class="remove-nested mt-2 text-sm text-red-600 hover:text-red-800 transition">
            <i class="fa-solid fa-trash mr-1"></i>Remove Sub-County
          </button>
          </div>

    
      `
    }
  }

  getSubCountyNameAttribute(timestamp) {
    const countyId = this.containerTarget.closest(".county-fields")
      .querySelector("input[name^='district[counties_attributes]']")
      .name.match(/\[(\d+)\]/)[1]

    return `district[counties_attributes][${countyId}][sub_counties_attributes][${timestamp}][name]`
  }

  getSubCountyDestroyAttribute(timestamp) {
    const countyId = this.containerTarget.closest(".county-fields")
      .querySelector("input[name^='district[counties_attributes]']")
      .name.match(/\[(\d+)\]/)[1]

    return `district[counties_attributes][${countyId}][sub_counties_attributes][${timestamp}][_destroy]`
  }
}