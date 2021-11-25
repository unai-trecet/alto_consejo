const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery/src/jquery',
  jQuery: 'jquery/src/jquery',
  jquery: 'jquery/src/jquery',
  Popper: ['@popperjs/core', 'default'],
  moment: 'moment/moment'
}))

module.exports = environment

