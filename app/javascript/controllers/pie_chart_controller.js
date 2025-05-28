// app/javascript/controllers/pie_chart_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    percentages: Array,
  };

  connect() {
    if (typeof ApexCharts === "undefined") {
      console.error("ApexCharts is not loaded.");
      return;
    }

    console.log("Percentages:", this.percentagesValue);

    const options = {
      series: this.percentagesValue,
      colors: ["#1C64F2", "#16BDCA", "#9061F9", "#FACA15"], // Four distinct colors
      chart: {
        height: 300,
        width: "100%",
        type: "pie",
      },
      stroke: {
        colors: ["white"],
        lineCap: "",
      },
      plotOptions: {
        pie: {
          labels: {
            show: true,
          },
          size: "100%",
          dataLabels: {
            offset: -25,
          },
        },
      },
      labels: [
        "Individual Beneficiaries",
        "Family Beneficiaries",
        "Organization Beneficiaries",
        "Inventories",
      ],
      dataLabels: {
        enabled: true,
        style: {
          fontFamily: "Inter, sans-serif",
        },
        formatter: function (val) {
          return val.toFixed(1) + "%";
        },
      },
      legend: {
        position: "bottom",
        fontFamily: "Inter, sans-serif",
      },
      yaxis: {
        labels: {
          formatter: function (value) {
            return value.toFixed(1) + "%";
          },
        },
      },
      xaxis: {
        labels: {
          show: false,
        },
        axisTicks: {
          show: false,
        },
        axisBorder: {
          show: false,
        },
      },
    };

    const chart = new ApexCharts(this.element.querySelector("#pie-chart"), options);
    chart.render();
  }

  changeTimeRange(event) {
    event.preventDefault();
    const timeRange = event.currentTarget.dataset.timeRange;
    window.location = `/dashboard?time_range=${timeRange}`; // Updated to redirect to index
  }
}