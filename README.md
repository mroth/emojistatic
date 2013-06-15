emojistatic
===========

Generate a bunch of static files useful for displaying Emoji on a website.  Designed to be easily deployed to Github Pages or Amazon S3, or just hotlink the pre-hosted version.

### What will you find within?

#### Emoji images

Sourced from github/gemoji, but with some advantages.

 - Resized as 64/32/24/20/16px variations.
 - Filesize optimized via `image_optim`.
 - HTML5 appcache files generated for each pixel size.  This will let you easily ensure a user's browser preloads and caches all the images.
 
#### Emoji image CSS sheets
 
If you intend you use the majority of emoji symbols, making 862 seperate HTTP requests can sometimes be a bit much.  Sprite sheets could solve this problem, but have non-trivial memory overhead when being used many with a file of large size.  Thus, we use the Data-URI embedding technique to embed all emoji symbols of a specific pixel size directly into a CSS file.

#### Generated CSS font-face to assist with natively using Emoji on supported Apple devices

When on a device that supports Emoji natively (for example, Safari on MacOSX 10.7+), you probably will want to use the native support and not fall back to images.

However, there are some big problems with this:

 - In a text span with mixed Emoji and regular alphanumeric characters (say, for example, rendering tweets), the regular characters will look _horrible_.
 - if you don't force the font, then many common Emoji characters will render as their plain Unicode variants (e.g. &#x270c; versus ![native](build/images/16/270c.png)), which certainly isn't as fun.
 
We solve this problem by generating a custom CSS font-family which maps only the appropriate unicode ranges to the local Apple font, and allows us to fall back to whatever other font we like for the rest of the characters.  Note this technique currently doesn't support double-byte Emoji glyphs (thankfully of which there are only a dozen or so).

<!-- TBD
#### Vendored copies of the js-emoji library

Since it's pretty awesome and you'll probably end up wanting to use it in conjunction with the above anyhow.
-->

#### All files contain minified and/or gzipped versions

Make every byte count. 

Using the pregenerated copies
-----------------------------

Simply grab the files from the [`/build`](/build) directory and stick them on AWS S3 or GitHub Pages or whatever.

You can also use the sample ones hosted with this repository at http://emojistatic.github.io/ !

Rolling your own
----------------

### Get dependencies

Clone the repository, then initialize the submodules via:

    git submodule update --init

You'll need dependencies for image processing, on MacOSX with Homebrew, for example, you would do:

    brew install imagemagick advancecomp gifsicle jpegoptim jpeg optipng pngcrush

Bundle to get ruby dependencies

    bundle install

### Configuration
Finally, you'll want to edit `config.yml` to add the domain of the host you'll be deploying to.  (This is really only needed for the cache manifests to have absolute URLs, which is needed if they are going to be on a different domain than your main content.  If not, set it to blank and you'll get relative URLs.)

### Hacking on emojistatic

Rake file tasks are extremely powerful way to handle generators such as this in an efficient manner, but they are confusing if you are used to more conventional usages of rake.  I recommend watching [Jim Weirich's fantastic "Power Rake" talk][1] to really grok them.

No tests here yet, if we start getting pull requests than perhaps we'll make some!

[1]: http://www.confreaks.com/videos/988-goruco2012-power-rake
