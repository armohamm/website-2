# Defacto Websites

 [![CircleCI branch](https://img.shields.io/circleci/project/github/DefactoSoftware/website/master.svg)](https://circleci.com/gh/DefactoSoftware/website)

The source code for our websites, built with [Middleman](https://middlemanapp.com/) and deployed to [Netlify](https://www.netlify.com/):

[https://www.defacto.nl](https://www.defacto.nl)

[![Netlify Status](https://api.netlify.com/api/v1/badges/76e34dcf-3a79-4b10-951c-af6bb0956126/deploy-status)](https://app.netlify.com/sites/defacto-nl/deploys)

[https://www.defactolearning.de](https://www.defactolearning.de)

[![Netlify Status](https://api.netlify.com/api/v1/badges/a15c1016-aea4-482d-ad20-218cfbb8249f/deploy-status)](https://app.netlify.com/sites/defacto-de/deploys)

[https://en.defacto.nl](https://en.defacto.nl)

[![Netlify Status](https://api.netlify.com/api/v1/badges/c08b69ab-87c7-4d09-bab0-564495bdd413/deploy-status)](https://app.netlify.com/sites/defacto-en/deploys)

More detailed information can be found at the [Wiki](https://github.com/DefactoSoftware/website/wiki).

## Dependencies

-   Ruby 2.4.3 (install with [rbenv](https://github.com/sstephenson/rbenv))
-   Bundler

To install other dependencies run `bundle install` from the root of the project.

## Rake Commands

### Serve

Start [Middleman](https://middlemanapp.com) server and browse to [http://localhost:4567](http://localhost:4567):

```bash
rake serve:nl
rake serve:de
rake serve:en
```

### Useful links for debugging

- http://localhost:4567/__middleman/config/
- http://localhost:4567/__middleman/sitemap/

### Build

```bash
rake build:nl
rake build:de
rake build:en
```

### Test (and build before)

```bash
rake test:nl
rake test:de
rake test:en
rake test # Tests all builds with HTML-proofer
```

## Thanks to :heart:

- [Middleman](https://middlemanapp.com/)
- [Middleman Blog](https://github.com/middleman/middleman-blog)
- [Middleman Deploy](https://github.com/karlfreeman/middleman-deploy)
- [Middleman Search](https://github.com/manastech/middleman-search) with [Lunr.js](https://github.com/olivernn/lunr.js/)
- [Middleman Syntax](https://github.com/middleman/middleman-syntax)
- [Middleman Minify HTML](https://github.com/middleman/middleman-minify-html)
- [Bourbon](https://github.com/thoughtbot/bourbon/)
- [Thoughtbot](https://github.com/thoughtbot)
- [Builder](https://github.com/jimweirich/builder/)
- [Rake](https://github.com/ruby/rake)
- [Nokogiri](https://github.com/sparklemotion/nokogiri)
- [HTML-proofer](https://github.com/gjtorikian/html-proofer)
- [kramdown](https://kramdown.gettalong.org/)
- [What Input](https://github.com/ten1seven/what-input)
- [Icomoon](https://icomoon.io/)
- [Hound](https://houndci.com/)
- [Rubocop](https://github.com/rubocop-hq/rubocop)
- [CircleCI](https://circleci.com/)
- [Netlify](https://www.netlify.com/)
