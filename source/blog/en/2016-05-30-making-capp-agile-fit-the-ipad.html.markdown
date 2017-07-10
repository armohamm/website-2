---
title: "Making our app fit the iPad"
date: 2016-05-30 14:10 CEST
tags: CAPP Agile Learning, features, UI/UX
author: Frits
lang: en
image: images/blog/social/read-mode-1200x630.jpg
featured_image: images/blog/featured/20150530-read-mode.jpg
---

One of the first things I mentioned when I started working at [CAPP Agile Learning](/capp-agile-learning/) two months ago is that CAPP Agile Learning needed an overhaul on the iPad in portrait mode. The iPad, in my opinion, is the single most suitable device for information consumption; a handy, lightweight device that can be held like a book and needs no extra peripherals to work well.

## What was the deal?

The iPad Space views I had to work with were essentially squashed together desktop views, what resulted in a <del>less than good</del> awful reading experience. The navigation bars on desktop are viewed as sidebars. So the screen is built up in columns. This fits the typical landscape ratio of laptops and desktops very well. But on a smaller, portrait oriented screen, such as that on the iPad you would expect the interface to be built up in rows as opposed to columns. This would result in more usable space and a much nicer reading experience.

## Readability

My primary mission was to improve the focus of the user. Especially when learning, focus is key.

## Read mode

One way to improve focus is to minimize the clutter on the page. When a user reads, all clutter such as a navigation bar or chapter index are redundant and distractive. This called for a distraction free mode that hides the whole interface of CAPP Agile Learning. This leaves only the text to be read and results in an improved focus on the matter.

![Illustrated image of glasses](/images/blog/en/read-icon.png)

## Line length

To achieve optimal readability a text line needs to be [between 45 to 75 characters](http://webtypography.net/2.1.2){:target="_blank"}{:rel="noopener"}. Too narrow lines will result in having the eye travel back too often, which breaks the rhythm. Too long lines will result in having a difficult time to focus on the text. It also makes it more difficult to stay on the same line. I chose to aim around 75 characters per line which fits nicely within the bounds of a portrait iPad.

## Typeface

In 1982 Robin Nicholas and Patricia Saunders designed the sans serif typeface Arial to increase legibility on low resolution displays. Arial and Helvetica (from 1957, where Arial is based on) are two of the most used fonts on the web as a result.

Today, typical mobile devices have much better, higher density screens (324dpi vs. ~100dpi). This alone makes reading a much better experience, but it also allows serif fonts to be used. We conducted a small experiment among our colleagues to find out what font is preferred; Open Sans (sans serif) or Charter (serif).

We asked the readers to focus on information intake and focus and found a preference toward Charter.

Another thing noted by the readers was that the Charter font felt more 'book-ish' and because of that, more immersive. Obviously, I went for Charter in Read mode. In 'standard' mode I kept Open Sans, because it is the default font of the CAPP Agile Learning interface. The two fonts clashed enough to discard the introduction of another type of font in the same view.

## Font size

Larger fonts on websites is one of the current web trends that make a lot of sense. For a long time web designers applied font sizes equal to or even smaller than 12 pixels. This resulted in a lot of complaints among end-users. Especially older users experience more difficulty reading small text on the web. With forty year old readers, only half of the light in their environment gets through to their retinas compared to young adults.

## Screen size / (char count * typeface font) == base font size

Well, at least, something like that anyway. Combine line length and typeface with available screen real-estate and you will find out your base font size. Is it comfortable to read? Congratulations, your base font-size is ready. Is the font size too small? Try to take a little more space from the sides or reduce the line-length until everything feels 'right'. Is the font size too large? Add more margin on the sides (reduce the articles width).

Don't forget that the articles width is not the same on different screen sizes. Therefore it's always a good idea to limit the maximum width:

~~~scss
article {
  margin: 0 auto; // center article
  max-width: 640px; // keep within optimal character range
  padding: 1em; // prevent text to stick to sides of screen
}
~~~

## Harmonious font sizes

To calculate font sizes I used the [type-scale](http://type-scale.com/){:target="_blank"}{:rel="noopener"} tool. This generates a series of harmonious values for headings and small text, which can be applied to the base font size.

To make life easier I added a series of three different scales as arrays in the SCSS typography variables file.

~~~scss
// h1, h2, h3, h4, base, small
$minor-third:    2.074em, 1.728em, 1.44em,  1.2em,   1em, 0.833em;
$major-third:    2.441em, 1.953em, 1.563em, 1.25em,  1em, 0.8em;
$perfect-fourth: 3.157em, 2.369em, 1.777em, 1.333em, 1em, 0.75em;
~~~

To set the type scale of your choice just set ~~~$type-scale: $major-third;~~~
After that assign the variables from the array to the appropriate tags like this:

~~~scss
h1 { font-size: nth($type-scale, 1); }
h2 { font-size: nth($type-scale, 2); }
h3 { font-size: nth($type-scale, 3); }
h4 { font-size: nth($type-scale, 4); }
small { font-size: nth($type-scale, 6); }
~~~

## Animation

With the removal of almost all interface when entering reading mode it will be important to keep the user informed about what just happened. Animation is a great way to guide the eye towards points of interest.

In the gif below, you see that almost all the different elements move off-screen. Except for the read-mode button. The fact that the read mode button stays on-screen gives the user the impression that it's a toggle for said mode.

![Animated preview of reading mode](/images/blog/en/animation-capp-agile.gif)

## Hardware acceleration

Apple was one of the first companies that really focussed on delivering a smoothly animated interface with iOS. This has led to new and innovative ways to guide users through an interface more naturally. To deliver the same high performance animations in the browser, some css tricks are needed. The trick is to offload screen calculations to the GPU. If a lot of stuff is being animated at the same time, software rendering (CPU) tends to stutter. Hardware rendering will, in most cases, give a smooth 60fps experience.

In the example below you can see the difference between software and hardware calculated positioning.

## Software rendered

~~~scss
.animate-me {
  position: fixed;
  left: 0;
  bottom: 0;
  width: 60px;
  transition: left 0.2s ease;

  .hide {
    left: -60px; // Software rendering (CPU)
  }
}
~~~


## Hardware accelerated

~~~scss
.animate-me {
  position: fixed;
  left: 0;
  bottom: 0;
  width: 60px;
  transition: transform 0.2s ease;

  .hide {
    transform: translateY(-60px); // Hardware accelerated (GPU)
  }
}
~~~

Transformations do not work the same as standard positioning. When positioning with percentages, the units are relative to the parent. In case of fixed, 100% would be the whole screen width. With transformations, 100% would be the whole width of the element you are targeting. If you want the transformation to have an offset of 100% screen width you can use ```transform: translateY(100vw);```

## Changing layout order

When changing a layout dramatically you often find yourself asking how to moving around different building blocks of your website / app. In my case I had to change the order of the chapter index and chapter information:

![Comparison between desktop and tablet view](/images/blog/en/order-capp-agile.png)

Fortunately flexbox can help you with that:

~~~scss
.container {
  display: flex;
  flex-direction: column;

  .chapter-information {
    order: 1;
  }

  .chapter-index {
    order: 2;
  }
}
~~~

This eliminates the need for javascript or dirty, limiting positioning tricks.

## Wrap up

All in all there's a lot to be taking into account when converting a legacy product to fit another kind of device. Tablets are in my opinion consumption products where laptops are true production machines. This calls for some major rethinking of every aspect of the chapter views.

I'm very glad with how it turned out in the end. Reading chapters on the iPad is a breeze, and all in all the interface works and looks a lot nicer. You can check out the end result in our app.
