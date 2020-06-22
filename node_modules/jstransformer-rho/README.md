# jstransformer-rho [![The MIT License][license-img]][license-url]

[Rho](https://github.com/inca/rho) support for [JSTransformers][jstransformers-url]

[![travis build status][travis-img]][travis-url] [![coverage status][coveralls-img]][coveralls-url] [![dependency status][david-img]][david-url] [![npmjs.com][npmjs-img]][npmjs-url]


## Install
```
npm install jstransformer-rho --save
```


## Usage
> For more use-cases see the **tests** in [test folder](./test) or see the [JSTransformer API](http://github.com/jstransformers/jstransformer#api) for more details.

```js
var rho = require('jstransformer')(require('jstransformer-rho'));

rho.render('Hello *world*!').body
//=> '<p>Hello <strong>world</strong>!</p>'
```


## Contributing
Pull requests and stars are always welcome. For bugs and feature requests, [please create an issue](https://github.com/jstransformers/jstransformer-rho/issues/new).


## License
[The MIT License][license-url]


[npmjs-url]: https://www.npmjs.com/package/jstransformer-rho
[npmjs-img]: https://img.shields.io/npm/v/jstransformer-rho.svg

[license-url]: ./LICENSE
[license-img]: https://img.shields.io/badge/license-MIT-blue.svg

[travis-url]: https://travis-ci.org/jstransformers/jstransformer-rho
[travis-img]: https://img.shields.io/travis/jstransformers/jstransformer-rho.svg

[coveralls-url]: https://coveralls.io/r/jstransformers/jstransformer-rho
[coveralls-img]: https://img.shields.io/coveralls/jstransformers/jstransformer-rho.svg

[david-url]: https://david-dm.org/jstransformers/jstransformer-rho
[david-img]: https://img.shields.io/david/jstransformers/jstransformer-rho.svg

[jstransformers-url]: http://github.com/jstransformers
