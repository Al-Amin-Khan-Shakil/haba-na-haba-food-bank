import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["district", "county", "subCounty"]
  static values = {
    basePath: {
      type: String, default: window.location.pathname.split('/')[1]
    }
  }

  connect() {
    this.initializeCounties()
    this.initializeSubCounties()
  }

  async initializeCounties() {
    if (!this.hasDistrictTarget) return

    const districtId = this.districtTarget.value
    if (districtId) {
      await this.loadCounties()
    }
  }

  async initializeSubCounties() {
    if (!this.hasCountyTarget) return

    const countyId = this.countyTarget.value
    if (countyId) {
      await this.loadSubCounties()
    }
  }

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

  rebuildSelect(select, data) {
    const initialValue = select.dataset.initialSelection
    select.innerHTML = ''
    this.addDefaultOption(select)

    data.forEach(item => {
      select.add(new Option(item.name, item.id))
    })

    if (initialValue && this.optionExists(select, initialValue)) {
      select.value = initialValue
    }
  }

  optionExists(select, value) {
    return Array.from(select.options).some(option => option.value === value)
  }

  addDefaultOption(select) {
    const defaultText =
      select === this.countyTarget ? "Select County" :
      select === this.subCountyTarget ? "Select Sub-County" :
      "Select Option"

    select.add(new Option(defaultText, ""))
  }
}
