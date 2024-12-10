document.addEventListener("DOMContentLoaded", () => {
  const countiesContainer = document.getElementById("counties");

  document.addEventListener("click", (event) => {
    if (event.target.classList.contains("add-county")) {
      event.preventDefault();
      const newCounty = countiesContainer.dataset.template.replace(
        /NEW_COUNTY/g,
        new Date().getTime()
      );
      countiesContainer.insertAdjacentHTML("beforeend", newCounty);
    }

    if (event.target.classList.contains("remove-county")) {
      event.preventDefault();
      event.target.closest(".county").remove();
    }

    if (event.target.classList.contains("add-sub-county")) {
      event.preventDefault();
      const countyContainer = event.target.closest(".county");
      const subCountiesContainer =
        countyContainer.querySelector(".sub-counties");
      const newSubCounty = subCountiesContainer.dataset.template.replace(
        /NEW_SUB_COUNTY/g,
        new Date().getTime()
      );
      subCountiesContainer.insertAdjacentHTML("beforeend", newSubCounty);
    }

    if (event.target.classList.contains("remove-sub-county")) {
      event.preventDefault();
      event.target.closest(".sub-county").remove();
    }
  });
});
