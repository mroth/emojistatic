# ![e](images/24/1f4e7.png)![m](images/24/24c2.png)![o](images/24/1f60f.png)![j](images/24/1f3b7.png)![i](images/24/2139.png)![s](images/24/1f4b0.png)t![a](images/24/1f170.png)t![i](images/24/1f4cd.png)![c](images/24/00a9.png)![!](images/24/2757.png)

This is a hosted instance of [emojistatic](https://github.com/mroth/emojistatic), a set of static resources to help with displaying Emoji symbols on websites.  For a better explanation of what all these files are and why you would want to use them, check out the [README for emojistatic](https://github.com/mroth/emojistatic/README.md).

Directory structure
-------------------

### Images
Have at them:

    /images/16/*.png
    /images/20/*.png
    /images/24/*.png
    /images/32/*.png
    /images/64/*.png

Substitute the wildcard with the lowercase unified Unicode codepoint representing the emoji glyph you want.  For example, if you want a 32px poop glyph (and who wouldn't?), he would live at [`/images/32/1f4a9.png`](/images/32/1f4a9.png).

### HTML5 Cache Manifests
For each of the image sets can be found at the following locations:

    /manifests/emoji-16px-images-manifest.appcache
    /manifests/emoji-20px-images-manifest.appcache
    /manifests/emoji-24px-images-manifest.appcache
    /manifests/emoji-32px-images-manifest.appcache
    /manifests/emoji-64px-images-manifest.appcache

### CSS Sheets
Can be found at the following location pattern:

    /css-sheets/emoji-16px.css
    /css-sheets/emoji-16px.min.css
    /css-sheets/emoji-16px.min.css.gz

Substitute for the desired pixel size.

### EmojiFont CSS Ruleset

Is located at [`/emojifont/emojifont.css`](/emojifont/emojifont.css) (see also the [minified](/emojifont/emojifont.min.css) and [min+gzipped](/emojifont/emojifont.min.css.gz) versions).
