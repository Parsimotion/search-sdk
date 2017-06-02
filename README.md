# lib-coffee-seed

[![NPM version](https://badge.fury.io/js/lib-coffee-seed.png)](http://badge.fury.io/js/lib-coffee-seed)

[Installation instructions](https://github.com/Parsimotion/lib-coffee-seed/wiki/Installation-Instructions)

# Publish instructions

``` Console
> grunt bump:[major|minor|patch]
#If you'd like to test it in your local environment
> npm install . -g 
or
> cd path/to/project/that/uses/this/package
> npm install path/to/this/package
```
Test your package in some project and make sure it works.
When you are absolutely sure

``` Console
> git push origin master
> git push origin master --tags
> npm publish
```
