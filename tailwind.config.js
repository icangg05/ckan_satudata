module.exports = {
  prefix: 'tw-',
  content: [
    './ckan/templates/**/*.html',
  ],
  corePlugins: {
    preflight: false,
  },
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
