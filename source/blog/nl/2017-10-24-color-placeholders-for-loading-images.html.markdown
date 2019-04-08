---
title: "Color Placeholders for Loading Images"
date: 2017-10-24 08:00 CEST
tags: Development, JavaScript, CSS
author: Matthijs
lang: nl
image: images/blog/social/color-placeholders-for-loading-images-1200x630.jpg
featured_image: images/blog/featured/20181024-color-placeholders.png
header_image: moods/plate.jpg
canonical_url: https://en.defacto.nl/blog/color-placeholders-for-loading-images/
---

__In my previous blog post [Flexible cover images using intrinsic ratio](/blog/flexible-cover-images-using-intrinsic-ratio/) I wrote about how to maintain the aspect ratio for cover images. In this follow-up I will explain how to enhance the user experience by using color placeholders for images while they are being loaded.__

When loading images it can take a while before they appear on screen. This depends on several factors like image size and available bandwidth. To bridge this gap it's nice for the user to know that the image is on its way. The most elegant approach I've seen (e.g. on Pinterest) is the use of color placeholders. In the animation below you can see how we use this in CAPP Agile Learning.

![Loading cover images in CAPP Agile Learning](/images/blog/capp-agile-space-tile-loading.gif)

Let's break down what's happening here:

1.  First the dominant image color is applied to the element's background.
2.  We hide the image while it's being loaded.
3.  When the image is done loading we fade it in.

For me the most challenging step is extracting the dominant color from the image. We'll get to that later in this post, so let's assume we've got the color we need.

The most basic example (without the fade-in effect) is applying the color directly to the background of the image element using CSS:

```html
<img href="image.png" width="400px" height="200px" style="background-color: #e66b57">
```

Note that the image has a `width` and `height` set. Without it the image would be 0x0 pixels before it's loaded and the `background-color` would not be visible.

## Loading and Fading in the Image

In the example below we apply the dominant color to a wrapping element instead of the image itself. This is because we want to show the background-color while the image is hidden and fading in.

```html
<div class="image-color" style="background-color: #e66b57">
  <img href="image.png" width="400px" height="200px">
</div>
```

The styling (using SCSS for this example) is fairly simple:

```scss
.image-color {
  display: inline-block;

  img {
    opacity: 0;
    transition: opacity 0.6s ease;
  }

  &.loaded img {
    opacity: 1;
  }
}
```

We hide the `img` element by setting `opacity: 0;`. When the `loaded` class gets added to the `.image-color` wrapper the `img` receives `opacity: 1;`. To fade-in the image we apply a `transition` to the opacity property.

Finally we need some JavaScript to detect when the image is loaded:

```js
$('.image-color').each(function () {
  var $wrapper = $(this);
  var img = $wrapper.find('img')[0];

  var tempImg = new Image();
  tempImg.src = img.src;
  tempImg.onload = function () {
    $wrapper.addClass('loaded');
  };
});
```

In this basic example we iterate over all `.image-color` elements. We create a temporary `new Image()` in memory and set its `src` attribute to the `src` attribute of the original image. When the `onload` callback is fired it means the image is loaded, and we can add the `loaded` class.

**[Demo](https://codepen.io/snap/pen/avQzzG/)** (with comments).

Instead of an image tag you could also use a background image. See this **[demo](https://codepen.io/snap/pen/RWqNLw/)** how this goes really well together with [Intrinsic Ratio](/blog/flexible-cover-images-using-intrinsic-ratio/).

## Extracting the Dominant Image Color

There are several ways to extract the dominant/average color of an image. You can find a bunch of online tools that do this for you or if you have Photoshop you can select `Filter > Blur > Average`. Another option is using the [ImageMagick command-line](https://imagemagick.org/script/command-line-processing.php):

```bash
convert path/or/url/to/image.png -resize 1x1 txt:-
```

But it gets a bit more complicated when you don't know what image will be served. Our goal is to display the color before the image is loaded, but extracting the color is only possible when the image is fully loaded.

To get around this issue we will have to process the image server-side. For example you could extract the color whenever someone visits the page. Or even better, when the image is uploaded to the server so you can store the color in the database. I prefer the latter because this will reduce load time.

I found a few ways to **extract the dominant/average color in Ruby**. The reason I'm listing multiple ways of doing this is that they all return different colors. Decide for yourself what gives the best result for you :)

Using **[RMagick](https://github.com/rmagick/rmagick)** (Ruby bindings for ImageMagick):

```rb
image = Magick::Image.read("path/to/image.png").first
color = image.to_color(image.scale(1, 1).pixel_color(0, 0))
```

```rb
image = Magick::Image.read("path/to/image.png").first
histogram = image.quantize(1, Magick::RGBColorspace).color_histogram
color = image.to_color(histogram.keys.first)
```

Using **[Miro](https://github.com/jonbuda/miro)** (Ruby gem that extracts the dominant colors from an image):

```rb
Miro.options[:method] = "histogram" # optional
Miro.options[:color_count] = 1
color = Miro::DominantColors.new("path/to/image.png").to_hex.first
```

The results for the examples above:

![Result for the code examples](blog/dominant-colors.png)

As you can see the results diverge a lot. You could say these are not really the dominant colors, but more like an average blend. It might surprise you that we use Miro in CAPP Agile Learning (the result on the right), but we lighten the color with 20% to which gives us the best result:

```rb
def lighten_color(hex_color, amount=0.2)
  color = hex_color.gsub('#','')
  rgb = hex_color.scan(/../).map(&:hex).map { |color|
    [(color.to_i + 255 * amount).round, 255].min }
  "#%02x%02x%02x" % rgb
end
```

I also found a nice javascript alternative for extracting the dominant color called [color-thief](https://github.com/lokesh/color-thief/). So if you need a client-side solution or if you're running Node.js this might be worth checking out. If you know other good alternatives or techniques please let me know!

## Ember component

```js
// app/components/cover-image.js

import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['cover-image'],
  // ...
});
```

```hbs
{{cover-image image='' color=''}}
```

```scss
.cover-image {
  transition: opacity 0.3s ease;
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
  opacity: 0;

  &.loaded {
    opacity: 1;
  }
}
```
