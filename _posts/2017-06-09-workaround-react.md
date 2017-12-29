---
layout: post
title:  "Workaround React deprecation warnings"
date:   2017-06-09 07:25:20 +0000
last_modified_at: 2017-12-25 20:06:19
category: web
tags: [reactjs, npm]
---

* TOC
{:toc}
Recently I am working with
[react-select](https://github.com/JedWatson/react-select/) and was a bit
annoyed by these warnings shown in my Chrome developer tools console:

```
Warning: Accessing PropTypes via the main React package is deprecated. Use the prop-types package from npm instead.

Warning: AsyncCreatableSelect: React.createClass is deprecated and will be removed in version 16. Use plain JavaScript classes instead. If you're not yet ready to migrate, create-react-class is available on npm as a drop-in replacement.
```

It turns out that starting from React v15.5.0, the old way of accessing React.PropTypes and React.createClass has been [deprecated](https://facebook.github.io/react/blog/2017/04/07/react-v15.5.0.html).

A quick workaround is to downgrade React to a previous version. Here is what I did:

## The workaround

1. Figure out the currently installed version

    ```
    $ grep react package.json 
    "babel-plugin-transform-react-jsx": "^6.24.1",
    "babel-preset-react": "^6.24.1",
    "react": "^15.5.4",
    "react-dom": "^15.5.4",
    "react-paginate": "^4.4.2",
    "react-select": "^1.0.0-rc.3",
    ```

2. Figure out available versions

    ```
    $ npm view react versions
    ...
    '15.4.0',
    '15.4.1',
    '15.4.2',
    '15.5.0-rc.1',
    '15.5.0-rc.2',
    '15.5.0',
    ... 19 more items ]
    ```

3. Downgrade to v15.4.2, which is the latest stable version prior to v15.5.0

    ```
    $ npm install react@15.4.2 react-dom@15.4.2 --save-dev  
    ```

## A side note on [semantic versioning](http://semver.org)

The above command updated the package.json file like follows:

```
-    "react": "^15.5.4",
-    "react-dom": "^15.5.4",
+    "react": "^15.4.2",
+    "react-dom": "^15.4.2",
```

The caret (^) sign prefixing the version string is used by npm to specify a version _scope_, assuming the _semantic versioning_ scheme. A version string following the semantic versioning scheme has three parts, separated by dots. The three parts are major, minor, and patch version respectively, 

In addition to the caret (^) sign, there is also a tilde (~) sign which can prefix a version in package.json. These prefixes basically gives npm some freedom in choosing the version for a module: instead of only allowing the specified version to be installed, caret allows newer minor and patch versions (i.e., new features and bug fixes to existing features), whereas tilde allows newer patch versions (bug fixes) only.

By default, npm uses caret when adding a dependency to package.json, when requested by `--save` or `--save-dev`. In my case, I needed to limit the version to be prior to v15.5.0, therefore I replaced the caret by tildes, so that it becomes:

```
$ grep react package.json 
"babel-plugin-transform-react-jsx": "^6.24.1",
"babel-preset-react": "^6.24.1",
"react": "~15.4.2",
"react-dom": "~15.4.2",
"react-paginate": "^4.4.2",
"react-select": "^1.0.0-rc.3",
```
