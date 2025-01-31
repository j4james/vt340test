## Test files and output

* [j4james-test01.txt](j4james-test01.txt)
  [j4james-test01.jpg](j4james-test01.jpg)

## Notes on Hardware VT340 

* DECSDM (Sixel Display Mode), when enabled, DISABLES Sixel Scrolling
  in the Graphics Set-up screen and vice versa.

* Showing images with 16 colors messes up text foreground/background. 

  * Soft Terminal Reset does *not* reset color palette.

        CSI ! p
        echo $'\x9b!p'

  * Hard Terminal Reset does reset palette, but it takes a long time to
    execute as it goes through the whole power-on self-test again.
    echo $'\ec'

  * It is hard to reset colors from the builtin setup because the
    current color map is used for the color setup screen.

  * To reset colors from keyboard (without needing to look):

        [Set-Up] [Prev Screen] [Do] [Set-Up]

    That pulls up the palette editor and recalls the saved color map.

  * Unlike REGIS, sixel color numbering is different from VT340's setup
    screen numbering!!! No matter what number you assign a sixel color,
    it is only the order that you did the assignment that matters in
    terms of where it is put in the VT340 color map. Annoyingly, the
    first sixel color defined is mapped to VT color #1, not color #0.
    The sixth color assigned (color #7) becomes the foreground color. To
    set the background color, one must set all the other colors first.
    The sixteenth assigned color wraps around and modifies VT color #0.

  * For resetting the color palette programmatically, try using
    DECRQTSR to get the Color Table Report instead of using sixel
    commands.

  * QUESTION: How do I convert an image to sixteen colors, but with
    three of the colors (fg, bg, and bright) fixed and the others free?

  * Note: lsix splits the montage into rows to reduce waiting when
    there are more than 21 images to show. However, each montage has
    separate color map, which means the previous row's colors will get
    messed up. I'm not sure there's a good solution for this other
    than to force a fixed palette (grayscale a good idea?).

### Number of colors on a genuine VT340

  * A genuine VT340 can show 16 colors from a 12-bit palette,

    Which means there are 4096 (2^12) different colors available.

  * Red, Green, Blue vary from 0 to 100% intensity.

    RGB can specify 101*101*101 different colors (almost 2^20).

  * Hue varies from 0 to 360 degrees, Lightness and Saturation vary
    from 0 to 100%. (Hue 0 and 360 are identical).

    HLS can specify 359*101*101 different colors (almost 2^22).

  * Thus there are roughly 250 different RGB values and 1000 different
    HLS values for each possible color that can actually be shown.

### VT340 Screen Resolution 

Graphics screen resolution is 800x480, but sometimes is quoted as
800x500, which includes the 25th line (the status line).

  * The status line is only addressable by sending a special escape
    sequence

        tput tsl; tput rev; echo; echo -n $(date); tput fsl)

    Even if one wanted to muck with that, the status line ignores
    sixel commands, so it is still not possible to use it for graphics.

### REGIS

* To enter REGIS: send from host `ESC P 3 p`
* To exit REGIS: send from host `ESC \`  or hit Control-L
* Example of using REGIS

    clear
    echo -n $'\eP3p'		# Enter interactive REGIS mode
    echo -n $'P[150,200]W(S1)C(W(I1))[+100]C[+66]C(W(I2))[+33]' # RAF roundels
    echo -n $'\e\\'		# Exit REGIS mode


### Keyboard

* The ESC key on the LK-201 keyboard only functions in VT100 mode. 
  Instead, you must use ^[ or ^3.

  