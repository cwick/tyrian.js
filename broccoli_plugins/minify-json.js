'use strict';
var Filter = require('broccoli-filter');

function MinifyJSONFilter(inputTree, options) {
  if (!(this instanceof MinifyJSONFilter)) {
    return new MinifyJSONFilter(inputTree);
  }

  this.inputTree = inputTree;
}

MinifyJSONFilter.prototype = Object.create(Filter.prototype);
MinifyJSONFilter.prototype.constructor = MinifyJSONFilter;

MinifyJSONFilter.prototype.extensions = ['json'];
MinifyJSONFilter.prototype.targetExtension = 'json';

MinifyJSONFilter.prototype.processString = function (str) {
  return JSON.stringify(JSON.parse(str));
};

module.exports = MinifyJSONFilter;
