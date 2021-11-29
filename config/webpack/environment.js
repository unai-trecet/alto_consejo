const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
const path = require('path');
environment.plugins.append(
  'Provide', 
  new webpack.ProvidePlugin({
    $: path.resolve(path.join(__dirname, '../../node_modules', 'jquery')),
    jQuery: path.resolve(path.join(__dirname, '../../node_modules', 'jquery')),
    jquery: path.resolve(path.join(__dirname, '../../node_modules', 'jquery')),
    Popper: ['@popperjs/core', 'default'],
    moment: 'moment/moment',
  }),
)

const aliasConfig = {
  'jquery': path.resolve(path.join(__dirname, '../../node_modules', 'jquery')),
  'jquery-ui': 'jquery-ui-dist/jquery-ui.js'
};

environment.config.set('resolve.alias', aliasConfig);

module.exports = environment

