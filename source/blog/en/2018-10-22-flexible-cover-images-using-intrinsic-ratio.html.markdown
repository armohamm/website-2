---
title: "Flexible cover images using intrinsic ratio"
date: 2018-10-22 8:00 CEST
tags: Frontend, UI/UX, CSS
author: Matthijs
lang: en
image: images/blog/social/intrinsic-ratio-1200x630.png
featured_image: images/blog/featured/20181022-intrinsic-ratio.png
header_image: images/blog/flexible-cover-images-using-intrinsic-ratio/header.png
---

**We recently changed the way header images are displayed in [CAPP Agile Learning](/capp-agile-learning/). They used to be fixed height and were clipped at the sides depending on the screen resolution. This would hide parts of the image which got really annoying, especially when using text in the image that is being clipped. So what we needed was a way for the images to maintain their [aspect ratio](https://en.wikipedia.org/wiki/Aspect_ratio){:target="\_blank"}{:rel="noopener"}{:title="Aspect Ratio on Wikipedia"}.**

The solution to our problem was **intrinsic ratio**, which is often used for [creating responsive videos](http://alistapart.com/article/creating-intrinsic-ratios-for-video){:target="\_blank"}{:rel="noopener"}{:title="Creating intrinsic ratio for video"}. This technique makes use of the unique way `padding-top` and `padding-bottom` deal with percentage values, which will be interpreted as a percentage of the width of the containing element.

## Aspect ratio

The recommended dimensions for header images in CAPP Agile Learning are 1280 by 720 pixels. The aspect ratio for these dimensions is 16:9 (= 1280:720). To get the needed percentage we divide 9 by 16, which gives us 0.5625 or 56.25%.

![Aspect Ratio](images/blog/flexible-cover-images-using-intrinsic-ratio/aspect-ratio.png)

Now we can apply the intrinsic ratio trick:

```html
<div class="header-image">
  <div class="ratio"></div>
</div>
```

```scss
.header-image {
  width: 100%;

  &.ratio {
    padding-bottom: 56.25%;
  }
}
```

[View demo](http://codepen.io/snap/full/MwqGYy/){:target="\_blank"}{:rel="noopener"}{:title="Responsive intrinsic ratio"}

The problem with using this aspect ratio trick is that if the element has a `max-height` declared, it will not be respected. To get around this, we applied this hack to a [pseudo-element](https://developer.mozilla.org/en-US/docs/Web/CSS/Pseudo-elements){:target="\_blank"}{:rel="noopener"}{:title="Pseudo Elements"} instead:

```html
<div class="header-image"></div>
```

```scss
.header-image {
  min-height: 300px;
  max-height: 500px;

  &::before {
    content: "";
    display: block;
    padding-bottom: 56.25%;
  }
}
```

[View demo](http://codepen.io/snap/full/EVPmOZ/){:target="\_blank"}{:rel="noopener"}{:title="Responsive intrinsic ratio using pseudo-element"}

## Adding the image

This aspect ratio hack goes really well together with background images, especially in conjunction with [`background-size: cover;`](https://developer.mozilla.org/en-US/docs/Web/CSS/background-size){:target="\_blank"}{:rel="noopener"}{:title="Background size"}.

> Scales the image as large as possible and maintains image aspect ratio (image doesn't get squished). The image "covers" the entire width or height of the container. When the image and container have different dimensions, the image is clipped either left/right or top/bottom.

So if we use a 1280x720px background image it will cover the whole available area without being clipped. This is because `padding-bottom: 56.25%;` makes sure it will maintain the correct aspect ratio (16:9).

```scss
.header-image {
  background: url(header-image.png) center;
  background-size: cover;

  &::before {
    content: "";
    display: block;
    padding-bottom: 56.25%;
  }
}
```

In the [demo](http://codepen.io/snap/full/NGxgLr/){:target="\_blank"}{:rel="noopener"}{:title="Responsive intrinsic ratio w/ background image"} below I've added a CSS animation to demonstrate the effect of intrinsic ratio while resizing.

<p data-height="265" data-theme-id="0" data-slug-hash="NGxgLr" data-default-tab="css,result" data-user="snap" data-pen-title="Responsive intrinsic ratio w/ background image" class="codepen">See the Pen <a href="https://codepen.io/snap/pen/NGxgLr/">Responsive intrinsic ratio w/ background image</a> by Matthijs Kuiper (<a href="https://codepen.io/snap">@snap</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

That's all there is to it. With just a little CSS you can scale elements on the fly while maintaining their aspect ratio. If you have questions or cool ideas on intrinsic ratio, please let us know on [twitter](https://twitter.com/DefactoSoftware)!
