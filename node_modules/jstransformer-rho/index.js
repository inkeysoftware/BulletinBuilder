'use strict';

var rho = require('rho');
var Promize = require('promise')

exports.name = 'rho';
exports.inputFormats = ['rho', 'markdown', 'md'];
exports.outputFormat = 'html';

exports.render = rho.toHtml;
exports.renderAsync = function renderAsync (str) {
  return new Promize(function (resolve, reject) {
    rho.render(str, function (err, res) {
      if (err) return reject(err);
      resolve(res);
    });
  });
};
