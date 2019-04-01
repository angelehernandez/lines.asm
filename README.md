# lines.asm
Creates a line between left and right clicks


Assignment Overview

Due: Thursday January 31, 2019 at 5:00pm (submit via Canvas)
For the next two assignments you will build some of the nuts and bolts of your game.
Specifically, you will implement some core graphics and math functions. In this assignment, you
will create a line drawing routine.

Important Note: From now on you should do the following in any procedures that you write.
For any register that your code uses (except EAX), you should include that register in a USES
list at the start of the procedure. This preserves the values used by caller so that when your
function returns, the caller sees all the values in the registers that it did before the call (e.g.
callee save register convention). You may want to go back and add a USES list to any/all
procedures from Assignment 1.

Line Drawing
For the real task of this assignment, you will implement a line drawing routine. This routine will
be able to draw any line (vertical, horizontal, diagonal) within the game window (640x480). To
implement this procedure you will need to make good use of integer arithmetic, if-then-else
conditionals, and loops. In addition, you will draw pixels that comprise the line by calling a library
routine that we provide. In the next assignment, you will be expected to draw directly on the
screen using pointer operations.

Your line draw routine will look like this:
  DrawLine PROTO x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD

Where the screen coordinates (x0,y0) is the start of the line and (x1,y1) is the end of the line. All
coordinates are given as regular unsigned integers. Remember that the screen is 640x480, so
note the valid value ranges for the the x and y coordinates respectively. You should be able to
draw any type of line within this valid range. The color parameter specifies the color...duh. This
is also a DWORD value, but as you may recall our pixel depth is 8 bits. So this procedure will
only consider the least significant byte of color and use that as the color for the line.

You should use the following pseudocode to implement your LineDraw procedure. It uses the
Bresenham Line Drawing Algorithm which is a very famous routine in computer graphics.  Note
that you will have to figure out how to compute absolute value abs(). DrawPixel() is a library
function that we provide.

DrawLine(x0, y0, x1, y1, color)
  delta_x = abs(x1-x0)
  delta_y = abs(y1-y0)
  
  if (x0 < x1)
    inc_x = 1
  else
    inc_x = -1
    
  if (y0 < y1)
    inc_y = 1
  else
    inc_y = -1
  if (delta_x > delta_y)
    error = delta_x / 2
  else
    error = - delta_y / 2
    
  curr_x = x0
  curr_y = y0
  
  DrawPixel(curr_x, curr_y, color)
  
  while (curr_x != x1 OR curr_y != y1)
    DrawPixel(curr_x, curr_y, color)
    prev_error = error
    if (prev_error > - delta_x)
      error = error - delta_y
      curr_x = curr_x + inc_x
    if (prev_error < delta_y)
      error = error + delta_x
      curr_y = curr_y + inc_y

Library Routines
We provide a new library procedure called DrawPixel:
  DrawPixel PROTO x:DWORD, y:DWORD, color:DWORD
You should use this routine to perform the plotting work in the pseudocode above. It will draw a
single pixel on the screen at coordinates (x,y) with the color value given by color (using the
LSB as the 8-bit color value). We’re providing this service to you for this assignment. Be aware
that you will need to implement this next time.

Our library routines will test your procedures (and allow you to test them with various input
values). As you left click with the mouse, it will set (x0,y0) point. As you right click with the
mouse, it will set (x1,y1). Try clicking at various points on the screen to test that your routine
works for all values.

You don’t need to call the DrawLine routine yourself anywhere in your code -- our library is
doing this for you. If you want to use your new routines to upgrade your starfield from the last
assignment, feel free to do so. Note: If you try to call DrawLine from stars.asm, you will need
to make sure that it sees the right prototype for the DrawLine routine (can include lines.inc).

Getting Started
Download and unpack the assignment files from the courseweb page. Copy your stars.asm
and stars.inc from the last assignment -- you will need them for this assignment and all the
subsequent ones. Edit the make.bat file to set up paths just as you did for the last assignment.
When you implement the DrawLine procedure, make sure to add USES described above. You
can compile and execute your program from the command line or with the included make.bat
script. When everything is successfully compiled, your should be able to run lines.exe. This
should allow you to test/demo your assignment. Think carefully about useful test cases and use
the mouse to test as described above.
