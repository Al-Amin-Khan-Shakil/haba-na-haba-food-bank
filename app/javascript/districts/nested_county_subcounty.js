document.addEventListener("turbo:load", function () {
  let countyIdCounter = 0; // Initialize a counter for counties (starting from 0)
  let subCountyIdCounter = 0; // Counter for sub-counties

  const addCountyButton = document.getElementById("add-county");
  const countiesDiv = document.getElementById("counties");

  // Add a new county
  addCountyButton.addEventListener("click", function (e) {
    e.preventDefault();
    countyIdCounter++; // Increment the county ID counter
    const newCountyFields = document.createElement("div");
    newCountyFields.classList.add(
      "county-fields",
      "space-y-4",
      "p-4",
      "border",
      "border-gray-300",
      "rounded-lg",
      "bg-gray-50"
    );
    newCountyFields.setAttribute("data-county-id", countyIdCounter);

    // Add a new county input field
    newCountyFields.innerHTML = `
      <div class="field">
        <label for="district_counties_attributes_${countyIdCounter}_name" class="block text-sm font-medium text-gray-700">County Name</label>
        <input type="text" name="district[counties_attributes][${countyIdCounter}][name]" id="district_counties_attributes_${countyIdCounter}_name" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
        <input type="hidden" name="district[counties_attributes][${countyIdCounter}][_destroy]" id="district_counties_attributes_${countyIdCounter}__destroy">
      </div>

      <div class="sub_counties space-y-4" id="sub_counties_${countyIdCounter}"></div>

      <a href="#" class="add-sub-county inline-block bg-green-500 text-white px-4 py-2 rounded-md hover:bg-green-600">Add Sub-County</a>
      <a href="#" class="remove-county inline-block bg-red-500 text-white px-4 py-2 rounded-md hover:bg-red-600">Remove County</a>
    `;

    countiesDiv.appendChild(newCountyFields);

    // Add event listeners for add/remove sub-county functionality
    setupSubCountyAddRemove(newCountyFields, countyIdCounter);
  });

  // Event listener for removing counties
  countiesDiv.addEventListener("click", function (e) {
    if (e.target && e.target.classList.contains("remove-county")) {
      e.preventDefault();
      e.target.closest(".county-fields").remove();
    }
  });

  // Function to handle adding/removing sub-counties dynamically
  function setupSubCountyAddRemove(countyDiv, countyId) {
    const addSubCountyButton = countyDiv.querySelector(".add-sub-county");
    const subCountiesDiv = countyDiv.querySelector(".sub_counties");

    addSubCountyButton.addEventListener("click", function (e) {
      e.preventDefault();
      subCountyIdCounter++; // Increment the sub-county ID counter

      const newSubCountyFields = document.createElement("div");
      newSubCountyFields.classList.add(
        "sub-county-fields",
        "space-y-4",
        "p-4",
        "border",
        "border-gray-300",
        "rounded-lg",
        "bg-gray-50"
      );
      newSubCountyFields.setAttribute("data-sub-county-id", subCountyIdCounter);

      newSubCountyFields.innerHTML = `
        <div class="field">
          <label for="district_counties_attributes_${countyId}_sub_counties_attributes_${subCountyIdCounter}_name" class="block text-sm font-medium text-gray-700">Sub-County Name</label>
          <input type="text" name="district[counties_attributes][${countyId}][sub_counties_attributes][${subCountyIdCounter}][name]" id="district_counties_attributes_${countyId}_sub_counties_attributes_${subCountyIdCounter}_name" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
          <input type="hidden" name="district[counties_attributes][${countyId}][sub_counties_attributes][${subCountyIdCounter}][_destroy]" id="district_counties_attributes_${countyId}_sub_counties_attributes_${subCountyIdCounter}__destroy">
        </div>
        <a href="#" class="remove-sub-county inline-block bg-red-500 text-white px-4 py-2 rounded-md hover:bg-red-600">Remove Sub-County</a>
      `;

      subCountiesDiv.appendChild(newSubCountyFields);

      // Add event listener for removing sub-county
      newSubCountyFields
        .querySelector(".remove-sub-county")
        .addEventListener("click", function (e) {
          e.preventDefault();
          newSubCountyFields.remove();
        });
    });
  }
});
