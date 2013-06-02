emojistatic
===========

Generate a bunch of files useful for static hosting for using emoji on a website.

Contains
  * gemoji (with images optimized), in 64/32/24/16px variations
  * json data and spritesheets from emoji-data
  * js-emoji library files
  * generated CSS font-face to assist with natively using on Appple devices

All files contain minified and/or gzipped versions as appropriate.  HTML5 app-cache is generated for each directory to ensure a user's browser will cache for as long as possible.

Using the pregenerated copies
-----------------------------

Simply grab the files from the `build/` directory and stick them on S3 or GitHub pages or whatever.

You can also use the sample ones hosted with this repository at http://emojistatic.github.io/ !

Rolling your own
----------------

### Get dependencies

Clone the repository, then initialize the submodules via:

    git submodule update --init

You'll need dependencies for image processing, on a mac with homebrew, for example do:

    brew install imagemagick advancecomp gifsicle jpegoptim jpeg optipng pngcrush

Bundle to get ruby dependencies

    bundle install

### Configuration
Finally, you'll want to edit `config.yml` to add the domain of the host you'll be deploying to.  (This is really only needed for the cache manifests to have absolute URLs, which is needed if they are going to be on a different domain than your main content.  If not, set it to blank and you'll get relative URLs.)

### Hacking on emojistatic

Rake file tasks are extremely powerful way to handle generators such as this, but they are confusing if you are used to more conventional usages of rake.  I recommend watching [Jim Weirich's fantastic "Power Rake" talk][1] to really grok them.

No tests here yet, if we start getting pull requests than perhaps we'll make some!

[1]: http://www.confreaks.com/videos/988-goruco2012-power-rake
