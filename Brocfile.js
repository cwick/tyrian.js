var filterCoffeeScript = require('broccoli-coffee');
var mergeTrees = require('broccoli-merge-trees');
var filterES6Modules = require('broccoli-es6-module-filter');
var pickFiles = require('broccoli-static-compiler');
var optimizeRequireJs = require('broccoli-requirejs');
var env = require('broccoli-env').getEnv();
var minifyJSON = require('./broccoli_plugins/minify-json');

function processCoffeeFiles(tree) {
  tree = filterCoffeeScript(tree, { bare: true });
  tree = filterES6Modules(tree, { moduleType: 'amd' });
  return tree;
}

function compileGameEngine() {
  var src = processCoffeeFiles("two.js/src");
  var dependencies = pickFiles("two.js/lib", { srcDir: "/", destDir: "lib" });

  return pickFiles(mergeTrees([dependencies, src]), { srcDir: "/", destDir: "two.js" });
}

function optimizeCodeForProduction(tree) {
  return optimizeRequireJs(tree, {
    requirejs: {
      name: 'src/tyrian',
      out: 'src/tyrian.js',
      paths: {
        "two": "two.js",
        "jquery": "lib/jquery-2.1.1"
      },
      packages: [{
        name: "two",
        main: "two.js"
      }]
    }
  });
}

function optimizeAssetsForProduction(tree) {
  return minifyJSON(tree);
}

function compileTyrian() {
  var src = pickFiles(processCoffeeFiles("src"), { srcDir: "/", destDir: "src" });
  var lib = pickFiles("lib", { srcDir: "/", destDir: "lib" });
  var srcAndDependencies = mergeTrees([src, lib, compileGameEngine()]);
  var assets = pickFiles("assets", { srcDir: "/", destDir: "/assets" });
  var gameRunner = pickFiles("standalone", { srcDir: "/", destDir: "/", files: ["index.html"] })

  if (env == "production") {
    var requirejs = pickFiles("lib", { srcDir: "/", destDir: "/lib", files: ["require.js"] });
    srcAndDependencies = optimizeCodeForProduction(srcAndDependencies);
    srcAndDependencies = mergeTrees([srcAndDependencies, requirejs]);
    assets = optimizeAssetsForProduction(assets)
  }

  return mergeTrees([gameRunner, srcAndDependencies, assets]);

}

module.exports = compileTyrian();

