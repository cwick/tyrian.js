var path = require('path');
var filterCoffeeScript = require('broccoli-coffee');
var mergeTrees = require('broccoli-merge-trees');
var filterES6Modules = require('broccoli-es6-module-filter');
var pickFiles = require('broccoli-static-compiler');

function processCoffeeFiles(tree) {
  tree = filterCoffeeScript(tree, { bare: true });
  tree = filterES6Modules(tree, { moduleType: 'amd' });
  return tree;
}

function compileTwo() {
  var src = processCoffeeFiles("two.js/src");
  var dependencies = pickFiles("two.js/lib", { srcDir: "/", destDir: "lib" });

  return pickFiles(mergeTrees([dependencies, src]), { srcDir: "/", destDir: "two.js" });
}

function compileTyrian() {
  var src = pickFiles(processCoffeeFiles("src"), { srcDir: "/", destDir: "src" });
  var dependencies = compileTwo();
  var assets = pickFiles("assets", { srcDir: "/", destDir: "/", files: ["index.html"] });

  return mergeTrees([dependencies, src, assets]);

}

module.exports = compileTyrian();

