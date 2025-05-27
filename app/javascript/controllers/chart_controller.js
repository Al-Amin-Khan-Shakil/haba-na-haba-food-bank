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

    // Determine the maximum value across both datasets
    const allData = [...this.foodDataValue, ...this.donationDataValue];
    const maxValue = Math.max(...allData, 1); // Default to 1 if no data to avoid division by zero
    const yAxisMax = maxValue * 1.2; // Add 20% buffer to the top

    const options = {
      chart: {
        height: "100%",
        maxWidth: "100%",
        type: "line",
        fontFamily: "Inter, sans-serif",
        dropShadow: { enabled: false },
        toolbar: { show: false },
      },
      tooltip: {
        enabled: true,
        x: {
          formatter: (index) => {
            return this.datesValue[index - 1];
          },
        },
      },
      dataLabels: { enabled: false },
      stroke: { width: 6, curve: "smooth" },
      grid: {
        show: true,
        strokeDashArray: 4,
        padding: {
          left: 2,
          right: 2,
          top: -26,
          bottom: 20,
        },
      },
      series: [
        { name: "Food Requests", data: this.foodDataValue, color: "#1A56DB" },
        { name: "Donation Requests", data: this.donationDataValue, color: "#7E3AF2" },
      ],
      legend: { show: false },
      xaxis: {
        categories: this.datesValue,
        labels: {
          show: false,
        },
        axisBorder: { show: false },
        axisTicks: { show: false },
      },
      yaxis: {
        show: true,
        min: 0,
        max: yAxisMax,
        labels: {
          show: false,
        },
      },
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