/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx,ts,tsx}'],
  theme: {
    extend: {
      fontFamily: {
        geist: ['Geist', 'sans-serif'],
      },
      opacity: {
        98: '0.98',
      },
    },
  },
  plugins: [],
}
