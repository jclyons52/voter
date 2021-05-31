const path = require('path')

module.exports = {
	devServer: {
		disableHostCheck: true
	},
	publicPath: process.env.NODE_ENV === 'production'
    ? '/voter/'
    : '/',
	configureWebpack: {
		resolve: {
			symlinks: false,
			alias: {
				vue$: path.resolve('./node_modules/vue/dist/vue.esm-bundler.js')
			}
		}
	}
}
