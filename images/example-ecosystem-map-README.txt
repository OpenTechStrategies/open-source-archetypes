* Updating the Example Ecosystem Map diagram.

  The process for updating the Example Ecosystem Map diagram is:

  - Use 'dia' (0.97 or higher should be fine) to make your edits.  If
    you don't know much dia, ask kfogel, but View->Show Layers is your
    friend.

  - (optional) Use File->Page Setup to change all margins to 0.20cm.
    However, this may not be strictly necessary.  Try without and see. 

  - Do File->Export to produce a "Scalable Vector Graphics (.svg)" file.  

    IMPORTANT: Dia offers a few different flavors of SVG export.  Use
    the exact one listed above, *not* "SVG (plain)" nor "Cairo SVG".
    Also, don't bother trying Dia's built-in PNG export; it will lead
    to bad results.  We need to export "Scalable Vector Graphics" from
    Dia, and then use Gimp to convert that to PNG -- see next step.

  - Do 'gimp example-ecosystem-map.svg'.  

    Gimp will show an initial import dialog, asking you how you want
    to set the dimensions of the image (since an SVG has no particular
    dimensions natively).  In that dialog, *First break the chainlink*
    between "X ratio" and "Y ratio", and *then* set Width to 893 and
    Height to 640.
   
    IMPORTANT: You must break the X/Y ratio link first, before setting
    Width and Height, otherwise everything will be unnecessarily hard.

  - From Gimp, do File->Export to save 'example-ecosystem-map.png'.

    Although not strictly necessary, I check the "Interlacing (Adam7)"
    checkbox in the PNG export dialog, because interlaced seems like a
    good standard.

  - 'pdflatex framework-for-open-source-analysis.ltx' to rebuild the doc.
    Check that everything looks right.

  - Commit 'example-ecosystem-map.png'.  Yes, we're versioning the
    generated PNG, for build convenience.

../getty/gci/2019_on-site/gci-arches-ecosystem-map-session-20190111-labeled.png
is the main source for the diagram, by the way.
