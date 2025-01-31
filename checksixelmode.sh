#!/bin/bash

# Do terminals respond correctly to DECRQM (request info on a mode)
# for mode #80 (sixel display mode)?

mode=${1:-80}			# Use command line arg for mode optionally


# Array of DEC Private Modes (mostly lifted from Xterm ctlseqs, but
# with replacements and additions from the VT300 Text Programming Guide).
Ps=()
Ps[1]="Application Cursor Keys (DECCKM), VT100."
Ps[2]="Designate US ASCII/ANSI for character sets G0-G3 (DECANM), VT100."
Ps[3]="132 Column Mode (DECCOLM), VT100."
Ps[4]="Smooth (Slow) Scroll (DECSCLM), VT100."
Ps[5]="Reverse Video Screen (DECSCNM), VT100."
Ps[6]="Origin Mode (DECOM), VT100."
Ps[7]="Auto-Wrap Mode (DECAWM), VT100."
Ps[8]="Auto-Repeat Keys (DECARM), VT100."
Ps[9]="Send Mouse X & Y on button press.  (X10 xterm mouse protocol)."

Ps[10]="Show toolbar (rxvt)."			# Conflicts with VT-3xx-TP.
Ps[10]="Edit Mode (DECEDM)." 			# As documented by VT-3xx-TP.
Ps[11]="Line Transmit Mode (DECLTM)."	 	# Added from VT-3xx-TP.
Ps[12]="Start blinking cursor (AT&T 610)."
Ps[13]="Start blinking cursor, xterm." 		# Conflicts with VT-3xx-TP.
Ps[13]="Space compression field delimiter (DECSCFDM)" # As documented by VT-3xx-TP.
Ps[14]="XOR of blinking cursor control sequence and menu." # Conflicts with VT-3xx-TP.
Ps[14]="Transmit execution (DECTEM)."	# As documented by VT-3xx-TP.
Ps[16]="Edit key execution (DECEKEM)."	# Added from VT-3xx-TP.

Ps[18]="Print Form Feed (DECPFF), VT220."
Ps[19]="Set printer extent to full screen (DECPEX), VT220."
Ps[25]="Text cursor enable (DECTCEM), VT220."
Ps[30]="Show scrollbar (rxvt)."

Ps[35]="Tektronix mode (DECTEK), incorrect."	# As erroneously documented by VT-3xx-TP.
Ps[35]="font-shifting functions (rxvt)."	# As documented by Xterm
Ps[38]="Tektronix mode (DECTEK), VT240, xterm."	# As documented by Xterm

Ps[40]="Allow 80/132 mode, xterm."
Ps[41]="more(1) fix."
Ps[42]="National Replacement Character sets (DECNRCM), VT220."
Ps[43]="Graphics Expanded Print Mode (DECGEPM)."

Ps[44]="Margin bell, xterm."			# Conflicts with VT-3xx-TP.
Ps[44]="Graphics Print Color Mode (DECGPCM)."	# Also documented by Xterm.
Ps[44]="Graphics print color (DECGPCM)"		# As documented by VT-3xx-TP

Ps[45]="Reverse-wraparound mode, xterm."	# Conflicts with VT-3xx-TP.
Ps[45]="Graphics Print Color Space (DECGPCS)."	# Also documented by Xterm.
Ps[45]="Graphics Print Color Syntax (DECGPCS)."	# As documented by VT-3xx-TP.

Ps[46]="Start logging, xterm."			# Conflicts with VT-3xx-TP.
Ps[46]="Graphics Print Background (DECGPBM)."	# As documented by VT-3xx-TP.

Ps[47]="Use Alternate Screen Buffer, xterm."	# Conflicts with VT-3xx-TP.
Ps[47]="Graphics Rotated Print Mode (DECGRPM)."	# As documented by VT-3xx-TP.

Ps[53]="VT131 transmit (DEC131TM)."		# Added from VT-3xx-TP.
Ps[60]="Horizontal cursor coupling (DECHCCM)."	# Added from VT-3xx-TP.
Ps[61]="Vertical cursor coupling (DECVCCM)."	# Added from VT-3xx-TP.
Ps[64]="Page cursor coupling (DECPCCM)."	# Added from VT-3xx-TP.

Ps[66]="Application/Numeric keypad mode (DECNKM), VT320"
Ps[67]="Backarrow key sends backspace (DECBKM), VT340, VT420."
Ps[68]="Keyboard usage (DECKBUM)."		# Added from VT-3xx-TP.
Ps[69]="Left and right margin mode (DECLRMM), VT420 and up."
Ps[73]="Transmit rate limiting (DECXRLM)."	# Added from VT-3xx-TP.
Ps[80]="Sixel Display Mode (DECSDM)."
Ps[95]="Do not clear screen when DECCOLM is set/reset (DECNCSM), VT510 and up."
Ps[1000]="Send Mouse X & Y on button press and release. (X11 xterm mouse protocol)."
Ps[1001]="Use Hilite Mouse Tracking, xterm."
Ps[1002]="Use Cell Motion Mouse Tracking, xterm."
Ps[1003]="Use All Motion Mouse Tracking, xterm."
Ps[1004]="Send FocusIn/FocusOut events, xterm."
Ps[1005]="UTF-8 Mouse Mode, xterm."
Ps[1006]="SGR Mouse Mode, xterm."
Ps[1007]="Alternate Scroll Mode, xterm."
Ps[1010]="Scroll to bottom on tty output (rxvt)."
Ps[1011]="Scroll to bottom on key press (rxvt)."
Ps[1015]="Urxvt Mouse Mode."
Ps[1016]="SGR Mouse PixelMode, xterm."
Ps[1034]="Interpret “meta” key, xterm. This sets the eighth bit of keyboard input."
Ps[1035]="Enable special modifiers for Alt and NumLock keys, xterm."
Ps[1036]="Send ESC when Meta modifies a key, xterm."
Ps[1037]="Send DEL from the editing-keypad Delete key, xterm."
Ps[1039]="Send ESC when Alt modifies a key, xterm."
Ps[1040]="Keep selection even if not highlighted, xterm."
Ps[1041]="Use the CLIPBOARD selection, xterm."
Ps[1042]="Enable Urgency windowmanager hint when Control-G received, xterm."
Ps[1043]="Enable raising of the window when Control-G is received, xterm."
Ps[1044]="Reuse the most recent data copied to CLIPBOARD, xterm"
Ps[1046]="Enable switching to/from Alternate Screen Buffer, xterm."
Ps[1047]="Use Alternate Screen Buffer, xterm."
Ps[1048]="Save cursor as in DECSC, xterm."
Ps[1049]="Save cursor as in DECSC, switch to the Alternate Screen Buffer."
Ps[1050]="Set terminfo/termcap function-key mode, xterm."
Ps[1051]="Set Sun function-key mode, xterm."
Ps[1052]="Set HP function-key mode, xterm."
Ps[1053]="Set SCO function-key mode, xterm."
Ps[1060]="Set legacy keyboard emulation, i.e, X11R6, xterm."
Ps[1061]="Set VT220 keyboard emulation, xterm."
Ps[2004]="Set bracketed paste mode, xterm."


status=("not recognized" "set" "reset" "permanently set" "permanently reset")

echo "Querying mode #$mode. ${Ps[$mode]}"

if ! IFS=";$" read -a REPLY -t 0.25 -s -p $'\e[?'$mode'$p' -d y; then
    echo Terminal did not respond.
    exit 1
fi

echo "${status[${REPLY[1]}]}"


