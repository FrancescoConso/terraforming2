# terraforming2
Sound-reactive Processing sketch using the Minim library. Inspired by 80's wireframe graphics.
Inspired by Kraftwerk's live shows and the retro aesthetics of the 80's I wrote this sound reactive Processing Sketch. The concept is relatively simple: the sketch takes left and right audio channels of an audio input (in this case a .mp3 file, but theoretically the input of the PC's microphone or even a mixer are doable), perform a Fourier Transform on it and uses the values to change the elevation of the grid spots to draw a "terraformed" grid based on the audio. It's done in real-time with minimal delays.
You can see the sketch in action on this Youtube video:
[![Video of Terraforming2](http://img.youtube.com/vi/L7a5_hYzO_A/0.jpg)](http://www.youtube.com/watch?v=L7a5_hYzO_A)

The sketch is named "terraforming2" because in the first version (rightfully named "terraforming" without any number) had a performance issues, with too many lines of the grid being instantiated and drawn, compared to what the garbage collector could handle at the end of each frame. The problem was solved in terraforming2 by drawing the lines as two "coils" running through the grid horizontally and vertically. This pretty much means only two objects were instantiated each frame, rather than the twenty-two of the previous version to represent the same object.
