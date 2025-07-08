const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
    "./node_modules/flowbite/**/*.js",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        primarycolor: "#6dc13d",
        hoverprimarycolor: "#3ea303",
        primarytext: "#302C51",
      },
        backgroundImage: {
        "users-image": "url('/assets/users-image.svg')",
        "users-show": "url('/assets/users-show.svg')",
        "login-bg": "url('/assets/Shape.svg')",
        "custom-image": "url('/assets/african-kid.png')",
        "community-image": "url('/assets/community.png')",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
    require("flowbite/plugin"),
  ],
};
