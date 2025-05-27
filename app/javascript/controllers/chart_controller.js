// app/javascript/controllers/chart_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    foodData: Array,
    donationData: Array,
    dates: Array,
  };

  connect() {
    if (typeof ApexCharts === "undefined") {
      console.error("ApexCharts is not loaded.");
      return;
    }

    console.log("Food Data:", this.foodDataValue);
    console.log("Donation Data:", this.donationDataValue);
    console.log("Dates:", this.datesValue);

    const options = {
      chart: {
        height: "100%",
        maxWidth: "100%",
        type: "line",
        fontFamily: "Inter, sans-serif",
        dropShadow: { enabled: false },
        toolbar: { show: false },
      },
      tooltip: { enabled: true, x: { show: false } },
      dataLabels: { enabled: false },
      stroke: { width: 6, curve: "smooth" },
      grid: {
        show: true,
        strokeDashArray: 4,
        padding: { left: 2, right: 2, top: -26 },
      },
      series: [
        { name: "Food Requests", data: this.foodDataValue, color: "#1A56DB" },
        { name: "Donation Requests", data: this.donationDataValue, color: "#7E3AF2" },
      ],
      legend: { show: false },
      xaxis: {
        categories: this.datesValue,
        labels: {
          show: true,
          style: {
            fontFamily: "Inter, sans-serif",
            cssClass: "text-xs font-normal fill-gray-500 dark:fill-gray-400",
          },
        },
        axisBorder: { show: false },
        axisTicks: { show: false },
      },
      yaxis: { show: false },
    };

    const chart = new ApexCharts(this.element.querySelector("#line-chart"), options);
    chart.render();
  }

  changeTimeRange(event) {
    event.preventDefault();
    const timeRange = event.currentTarget.dataset.timeRange;
    window.location = `?time_range=${timeRange}`;
  }
}