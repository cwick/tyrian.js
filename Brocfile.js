var filterCoffeeScript = require('broccoli-coffee');
var mergeTrees = require('broccoli-merge-trees');
var filterES6Modules = require('broccoli-es6-module-filter');
var pickFiles = require('broccoli-static-compiler');
var optimizeRequireJs = require('broccoli-requirejs');
var env = require('broccoli-env').getEnv();

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

function optimizeForProduction(tree) {
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

function compileTyrian() {
  var src = pickFiles(processCoffeeFiles("src"), { srcDir: "/", destDir: "src" });
  var lib = pickFiles("lib", { srcDir: "/", destDir: "lib" });
  var srcAndDependencies = mergeTrees([src, lib, compileGameEngine()]);

  var assets = mergeTrees([
    pickFiles("assets", { srcDir: "/", destDir: "/", files: ["index.html"] }),
    pickFiles("converted_data", { srcDir: "/", destDir: "/converted_data" })
  ]);

  if (env == "production") {
    srcAndDependencies = optimizeForProduction(srcAndDependencies);
  }

  var requirejs = pickFiles("lib", { srcDir: "/", destDir: "/", files: ["require.js"] });

  return mergeTrees([requirejs, srcAndDependencies, assets]);

}

module.exports = compileTyrian();

