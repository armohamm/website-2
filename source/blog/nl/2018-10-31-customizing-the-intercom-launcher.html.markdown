---
title: "Customizing the Intercom Launcher"
date: 2018-10-31 08:00 CEST
tags: Development, JavaScript, CSS
author: Matthijs
lang: nl
image: images/blog/social/customizing-the-intercom-launcher-1200x630.png
featured_image: images/blog/featured/20181031-customizing-the-intercom-launcher.png
header_image: moods/art.jpg
canonical_url: https://en.defacto.nl/blog/customizing-the-intercom-launcher/
---

__We've been using [Intercom](https://www.intercom.com/){:target="_blank"}{:rel="noopener noreferrer"}{:title="Intercom App"} in CAPP Agile Learning for well over a year now, and like we said back then, it has really improved our support and in-app communication with users.__

A few weeks ago Intercom introduced their [new messenger](https://docs.intercom.com/a-guide-to-the-new-intercom-messenger/the-new-intercom-messenger){:target="_blank"}{:rel="noopener noreferrer"}{:title="The New Intercom Messenger"}, where they've added some new features and did an impressive redesign.

Before the update we applied a bit of styling to change the size of the launcher (the default is too big for our taste). But after the update this doesn't work anymore due to the fact that __Intercom renders everything inside an iframe__. I was hoping for a little bit more control over the size through the [App settings](https://docs.intercom.com/configure-intercom-for-your-product-or-site/customize-the-intercom-messenger/customize-the-intercom-messenger-basics){:target="_blank"}{:rel="noopener noreferrer"}{:title="Customize Intercom messenger basics"}, but this is limited to selecting a custom color.

![New vs Old Intercom launcher](/images/blog/new-vs-old-launcher.png)

This blog post shows you two ways how to customize the Intercom Launcher, but I will limit the examples to changing its size. The two options are:

1. Inject a stylesheet into the iframe
2. Create a custom launcher

---

## Inject a stylesheet into the iframe

I think Intercom started using iframes to isolate/sandbox their widgets, e.g. to prevent style leakage or even discourage custom styling all together. This is for a reason, so you might consider this a hack/quick fix.

<script src="https://gist.github.com/852cfed0ee22b07b5263ca04930705c8.js?file=script.js" type="text/javascript"></script>

We poll for the iframe to become ready, and append the `intercom.css` stylesheet to its head. Forgive me for the not so elegant polling, but this is because the Intercom Javascript API lacks a ready callback :(

The stylesheet that is injected by the script:

<script src="https://gist.github.com/852cfed0ee22b07b5263ca04930705c8.js?file=intercom.css" type="text/javascript"></script>

This stylesheet should __also be included in your app or website__ (or at least the first part). The first parts targets the launcher iframe itself, the second part targets the iframe content (SCSS version [here](https://gist.github.com/sn3p/852cfed0ee22b07b5263ca04930705c8#file-intercom-scss){:target="_blank"}{:rel="noopener noreferrer"}{:title="Intercom SCSS"}).

---

## Create a custom launcher

A custom launcher gives you more control over its appearance and behaviour. This is the "[official](https://docs.intercom.com/configure-intercom-for-your-product-or-site/customize-the-intercom-messenger/customize-the-intercom-messenger-technical){:target="_blank"}{:rel="noopener noreferrer"}{:title="Customize Intercom messenger technical"}" way to customize the launcher, and probably more future proof compared to injecting a stylesheet into the iframe. The example below is a smaller recreation of the original launcher.

First create a link with a mailto address, which serves as a fallback in case Intercom is not (yet) booted. Don't forget to replace `YOUR_APP_ID`.

<script src="https://gist.github.com/2f3e3c5ba51fd8733a29fc0b4ff95a42.js?file=index.html" type="text/javascript"></script>

The trick is to initialize Intercom with the `custom_launcher_selector` option. This selector should match the mailto link we've just created. By creating `onShow`, `onHide` and `onUnreadCountChange` callbacks we are able to deal with events. And finally we start polling for the `Intercom.boot` flag, which indicated if Intercom is booted. The `intercom-booted` class is added to make the launcher visible.

<script src="https://gist.github.com/2f3e3c5ba51fd8733a29fc0b4ff95a42.js?file=script.js" type="text/javascript"></script>

The styling is copied from the original launcher (for the most part):

<script src="https://gist.github.com/2f3e3c5ba51fd8733a29fc0b4ff95a42.js?file=intercom-launcher.scss" type="text/javascript"></script>

**Note:** The styling is in SCSS format. You can compile it to CSS [online](http://www.sassmeister.com){:target="_blank"}{:rel="noopener noreferrer"}{:title="SASS Meister"} or via command line: `sass --watch . --no-cache`.
Also, I didn't include vendor prefixes so you might want to add those. Or even better, use [Autoprefixer](https://github.com/postcss/autoprefixer){:target="_blank"}{:rel="noopener noreferrer"}{:title="Autoprefixer"}.

Last but not least, [turn off the Intercom Messenger launcher](https://docs.intercom.com/configure-intercom-for-your-product-or-site/customize-the-intercom-messenger/turning-off-the-intercom-messenger-launcher){:target="_blank"}{:rel="noopener noreferrer"}{:title="Turn off the Intercom launcher"}. Your newly created launcher is ready to take its place! For more information read the [docs](https://docs.intercom.com/configure-intercom-for-your-product-or-site/customize-the-intercom-messenger/customize-the-intercom-messenger-technical){:target="_blank"}{:rel="noopener noreferrer"}{:title="Customize Intercom messenger technical"}.

---

### Intercom's missing ready callback

The Intercom [JavaScript API](https://docs.intercom.com/configure-intercom-for-your-product-or-site/customize-the-intercom-messenger/the-intercom-javascript-api){:target="_blank"}{:rel="noopener noreferrer"}{:title="Intercom JavaScript API"} is lacking a `ready` callback, something I've missed from the beginning. There is an `Intercom.boot` flag to test if it's booted, but you still have to watch/poll it (like the example above). I've been talking to Sean, a really helpful Customer Support Engineer at Intercom, about this and he said:

> I'll tag this as a feature request, maybe we can look at getting it added at some point.

---

I hope this helps someone! If you have questions or improvements, please contact us on [Twitter](https://twitter.com/defactosoftware) or [Intercom](javascript:Intercom('show')) :)
