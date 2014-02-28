# cube.less
[![Build Status](https://travis-ci.org/sparanoid/cube.less.png)](https://travis-ci.org/sparanoid/cube.less)
[![devDependency Status](https://david-dm.org/sparanoid/cube.less/dev-status.png)](https://david-dm.org/sparanoid/cube.less#info=devDependencies)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/sparanoid/cube.less/trend.png)](https://bitdeli.com/free)

3D (animated) cube using only CSS.

## Demo

See this [demo page](http://sparanoid.com/lab/cube.less/). There's also a [live production site (WIP)](http://avoscloud.com/) using these cubes.

## Install

    bower install cube.less

## Options

### Mixins

#### .makecube

Main mixin, it has the following options:

##### @size

Default: `100px`

The length of a cube side.

##### @depth

Default: `50px`

Cube depth alone the Z-axis.

##### @rotate-x

Default: `0deg`

Rotate the cube along the X-axis.

##### @rotate-y

Default: `0deg`

Rotate the cube along the Y-axis.

##### @rotate-z

Default: `0deg`

Rotate the cube along the Z-axis.

#### .makeperspective

##### @perspective

Default: `2500`

Make canvas perspective to parent element.

### Additional Classes

#### .cube-border

No cube background, like ouline vision. apply it to cube container.

#### .cube-borderless

No outline, apply it to cube container.

#### .cube-unselectable

Make all cubes unselectable, apply it to cube parent wrapper, or specific cube. Both are ok.

## Setup

The following is a basic markup:

```html
...
<div class="cube-perspective">
  <span class="cube cube-01"><i></i><i></i><i></i><i></i><i></i><i></i></span>
  <span class="cube cube-02 cube-border"><i></i><i></i><i></i><i></i><i></i><i></i></span>
  <span class="cube cube-03 cube-borderless"><i></i><i></i><i></i><i></i><i></i><i></i></span>
  <span class="cube cube-04"><i></i><i></i><i></i><i></i><i></i><i></i></span>
</div>
...
```

## Animation

See [demo](https://github.com/sparanoid/cube.less/blob/master/demo/index.html).

## Dev Setup

    npm install && grunt server

## Author

**Tunghsiao Liu**

- Twitter: @[tunghsiao](http://twitter.com/tunghsiao)
- GitHub: @[sparanoid](http://github.com/sparanoid)

## Licenses

WTFPL
