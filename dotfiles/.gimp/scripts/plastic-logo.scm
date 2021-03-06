; plastic logo
;  
; --------------------------------------------------------------------
; version 1.0 by Michael Schalla 2003/02/17
; --------------------------------------------------------------------
;

(define (script-fu-plastic-logo inText inFont inFontSize inBackGroundColor inHighlightColor inTextColor inDarkColor inHighlightValue inThreshold inShrink inFeather inShadow inAbsolute inImageWidth inImageHeight inFlatten)
  (let*
    (
      ; Definition unserer lokalen Variablen

      ; Erzeugen des neuen Bildes

      (img  ( car (gimp-image-new 10 10 RGB) ) )
      (theText)
      (theTextWidth)
      (theTextHeight)
      (imgWidth)
      (imgHeight)
      (theBufferX)
      (theBufferY)

      ; Erzeugen einer neuen Ebene zum Bild
      (theLayer (car (gimp-layer-new img 10 10 RGB-IMAGE "Background" 100 NORMAL-MODE) ) )
      (theTextLayer (car (gimp-layer-new img 10 10 RGBA-IMAGE "Text" 100 NORMAL-MODE) ) )
      (theTextMask)

      (old-fg (car (gimp-context-get-foreground) ) )
      (old-bg (car (gimp-context-get-background) ) )
      ; Ende unserer lokalen Variablen
    )

    (gimp-image-add-layer  img theLayer 0)
    (gimp-image-add-layer  img theTextLayer 0)

    ; zum Anzeigen des leeren Bildes
    ; (gimp-display-new img)

    (gimp-context-set-background '(255 255 255) )
    (gimp-context-set-foreground '(0 0 0) )

    (gimp-selection-all  img)
    (gimp-edit-clear     theLayer)
    (gimp-selection-none img)

    (set! theText (car (gimp-text-fontname img theLayer 0 0 inText 0 TRUE inFontSize PIXELS inFont)))

    (set! theTextWidth  (car (gimp-drawable-width  theText) ) )
    (set! theTextHeight (car (gimp-drawable-height theText) ) )

    (set! imgWidth inImageWidth )
    (set! imgHeight inImageHeight )

    (if (= inAbsolute FALSE)
      (set! imgWidth (+ theTextWidth 20 ) )
    )

    (if (= inAbsolute FALSE)
      (set! imgHeight (+ theTextHeight 20 ) )
    )

    (set! theBufferX      (/ (- imgWidth theTextWidth) 2) )
    (set! theBufferY      (/ (- imgHeight theTextHeight) 2) )

    (gimp-image-resize img imgWidth imgHeight 0 0)
    (gimp-layer-resize theLayer imgWidth imgHeight 0 0)
    (gimp-layer-resize theTextLayer imgWidth imgHeight 0 0)

    (gimp-layer-set-offsets   theText theBufferX theBufferY)

    (gimp-edit-blend theText FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 0 0 FALSE 0 theTextHeight 0 0)
    ;(gimp-floating-sel-anchor theText theLayer)
    (gimp-floating-sel-anchor theText)
    (plug-in-gauss-iir 1 img theLayer 5 TRUE TRUE)

    (gimp-context-set-foreground inTextColor )
    (set! theText (car (gimp-text-fontname img theTextLayer 0 0 inText 0 TRUE inFontSize PIXELS inFont)))
    (gimp-layer-set-offsets   theText theBufferX theBufferY)
    ;(gimp-floating-sel-anchor theText theTextLayer)
    (gimp-floating-sel-anchor theText)

    (gimp-by-color-select theLayer (list inHighlightValue inHighlightValue inHighlightValue) inThreshold 0 FALSE FALSE 10 FALSE)

		(gimp-selection-shrink img inShrink )
		(gimp-selection-feather img inFeather )

    (gimp-context-set-foreground inHighlightColor )
    (gimp-edit-bucket-fill theTextLayer FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
    (gimp-selection-none img)

    (gimp-selection-all  img)
    (gimp-edit-clear     theLayer)
    (gimp-selection-none img)

    (gimp-context-set-foreground '(0 0 0) )
    (set! theText (car (gimp-text-fontname img theLayer 0 0 inText 0 TRUE inFontSize PIXELS inFont)))

    (gimp-layer-set-offsets   theText theBufferX theBufferY)

    (gimp-edit-blend theText FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 0 0 FALSE 0 0 0 theTextHeight)
    ;(gimp-floating-sel-anchor theText theLayer)
    (gimp-floating-sel-anchor theText)
    (plug-in-gauss-iir 1 img theLayer 5 TRUE TRUE)

    (gimp-by-color-select theLayer (list inHighlightValue inHighlightValue inHighlightValue) inThreshold 0 FALSE FALSE 10 FALSE)

		(gimp-selection-shrink img inShrink )
		(gimp-selection-feather img inFeather )

    (gimp-context-set-foreground inDarkColor )
    (gimp-edit-bucket-fill theTextLayer FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
    (gimp-selection-none img)

    (gimp-layer-add-alpha theTextLayer)
    (gimp-context-set-foreground '(255 255 255) )
    (set! theText (car (gimp-text-fontname img -1 0 0 inText 0 TRUE inFontSize PIXELS inFont)))
    (gimp-layer-set-offsets theText theBufferX theBufferY)
    (gimp-selection-layer-alpha theText)
    (gimp-selection-invert img)
    (gimp-edit-clear theTextLayer)
    (gimp-selection-none img)
    (gimp-image-remove-layer img theText)

    (if (= inShadow TRUE)
      (script-fu-drop-shadow img theTextLayer 2 2 5 '(0 0 0) 100 FALSE )
      ()
    )

    (gimp-context-set-background inBackGroundColor )
    (gimp-selection-all  img)
    (gimp-edit-clear     theLayer)
    (gimp-selection-none img)

    (if (= inFlatten TRUE)
      (gimp-image-flatten img)
      ()
    )

    (gimp-context-set-background old-bg)
    (gimp-context-set-foreground old-fg)

    (gimp-display-new     img)
    (list  img theLayer theText)

    ; Bereinigen Dirty-Flag
    ;(gimp-image-clean-all img)

  )
)

(script-fu-register
  "script-fu-plastic-logo"
  "Plastic..."
  "Creates a plastic-like logo."
  "Michael Schalla"
  "Michael Schalla"
  "October 2002"
  ""
  SF-STRING     "Text"                "Plastic"
  SF-FONT       "Font"                "Victoriana Display SSi"
  SF-ADJUSTMENT "Font size (pixels)"  '(100 2 1000 1 10 0 1)
  SF-COLOR      "Background Color"    '(255 255 255)
  SF-COLOR      "Color 1"             '(224 224 255)
  SF-COLOR      "Color 2"             '(128 128 255)
  SF-COLOR      "Color 3"             '(64 64 192)
  SF-ADJUSTMENT "                        "    '(208 0 255 1 1 0 1)
  SF-ADJUSTMENT "                           "  '(25 0 255 1 1 0 1)
  SF-ADJUSTMENT "                        "    '(0 0 10 1 1 0 1)
  SF-ADJUSTMENT "                           "  '(8 0 20 1 1 0 1)
  SF-TOGGLE     "               "          TRUE
  SF-TOGGLE     "                        "    FALSE
  SF-VALUE      "          (            )"  "300"
  SF-VALUE      "          (            )"  "100"
  SF-TOGGLE     "                  "        FALSE
)
(script-fu-menu-register "script-fu-plastic-logo"
		    "<Toolbox>/Xtns/Script-Fu/Extra Logos")
