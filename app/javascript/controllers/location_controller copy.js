// app/javascript/controllers/location_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["district", "county", "subCounty"]
  static values = {
    basePath: {
      type: String, default: window.location.pathname.split('/')[1]
    }
  }

  // Connect lifecycle method
  connect() {
    this.initializeCounties()
    this.initializeSubCounties()
  }

  // County initialization
  async initializeCounties() {
    if (!this.hasDistrictTarget) return

    const districtId = this.districtTarget.value
    if (districtId) {
      await this.loadCounties()
      this.preserveSelection(this.countyTarget)
    }
  }

  // SubCounty initialization
  async initializeSubCounties() {
    if (!this.hasCountyTarget) return

    const countyId = this.countyTarget.value
    if (countyId) {
      await this.loadSubCounties()
      this.preserveSelection(this.subCountyTarget)
    }
  }

  // Shared loader for counties
  async loadCounties() {
    const districtId = this.districtTarget.value
    if (!districtId) return

    try {
      const response = await fetch(`/${this.basePathValue}/load_counties?district_id=${districtId}`)
      const data = await response.json()
      this.rebuildSelect(this.countyTarget, data)
    } catch (error) {
      console.error("County loading failed:", error)
    }
  }

  // Shared loader for subcounties
  async loadSubCounties() {
    const countyId = this.countyTarget.value
    if (!countyId) return

    try {
      const response = await fetch(`/${this.basePathValue}/load_sub_counties?county_id=${countyId}`)
      const data = await response.json()
      this.rebuildSelect(this.subCountyTarget, data)
    } catch (error) {
      console.error("SubCounty loading failed:", error)
    }
  }

  // Generic select rebuilder
  rebuildSelect(select, data) {
    const currentValue = select.value
    const initialValue = select.dataset.initialSelection

    select.innerHTML = ''
    this.addDefaultOption(select)

    data.forEach(item => {
      select.add(new Option(item.name, item.id))
    })

    // Priority: current value > initial value
    const finalValue = currentValue || initialValue
    if (finalValue && this.optionExists(select, finalValue)) {
      select.value = finalValue
    }
  }

  // Preserve selection after reload
  preserveSelection(select) {
    const initialValue = select.dataset.initialSelection
    if (initialValue && this.optionExists(select, initialValue)) {
      select.value = initialValue
    }
  }

  // Helper: Check if option exists
  optionExists(select, value) {
    return Array.from(select.options).some(option => option.value === value)
  }

  // Helper: Add default option
  addDefaultOption(select) {
    const defaultText = select === this.countyTarget ?
      "Select County" : "Select Sub-County"
    select.add(new Option(defaultText, ""))
  }
}