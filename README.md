## Defacto websites

The source code for our websites:

[http://www.defacto.nl](http://www.defacto.nl)  
[http://www.defactolearning.de](http://www.defactolearning.de)  
[http://en.defacto.nl](http://en.defacto.nl)

More detailed information can be found at the [Wiki](https://github.com/DefactoSoftware/website/wiki).

##### Dependencies

- Ruby 2.3.3 (install with [rbenv](https://github.com/sstephenson/rbenv))
- Bundler

To install other dependencies run `bundle install` from the root of the project.

##### Server

Start [Middleman](https://middlemanapp.com) server and browse to [http://localhost:4567](http://localhost:4567):

```bash
rake serve:nl
rake serve:de
rake serve:en
```

##### Build

```bash
rake build:nl
rake build:de
rake build:en
```

##### Test (and build before)

```bash
rake test:nl
rake test:de
rake test:en
rake test # Test all locales
```

##### Deploy (and build + test before)

```bash
rake deploy:nl
rake deploy:de
rake deploy:en
rake deploy # Deploy all locales
```

`:nl` is deployed to [website/tree/gh-pages](https://github.com/DefactoSoftware/website/tree/gh-pages).

`:de` is deployed to [website-de/tree/gh-pages](https://github.com/DefactoSoftware/website-de/tree/gh-pages).

`:en` is deployed to [website-en/tree/gh-pages](https://github.com/DefactoSoftware/website-en/tree/gh-pages).

##### Useful links for debugging

- http://localhost:4567/__middleman/config/
- http://localhost:4567/__middleman/sitemap/

##### Thanks to

- [Middleman](https://middlemanapp.com/)
- [Middleman Search](https://github.com/manastech/middleman-search)
- [HTMLproofer](https://github.com/gjtorikian/html-proofer)
