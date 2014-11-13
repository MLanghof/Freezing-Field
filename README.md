Freezing-Field
==============

Since there have been [multiple](http://www.playdota.com/forums/showthread.php?t=1440827) [forum](http://www.playdota.com/forums/showthread.php?t=1441135) [threads](http://www.playdota.com/forums/showthread.php?t=1371372) in the playdota.com forum recently about the probability distribution of being hit by the explosions,
I attempted analytical approaches with different coordinate system choices [here](http://www.playdota.com/forums/showpost.php?p=9566597&postcount=28) and [here](http://www.playdota.com/forums/showpost.php?p=9566664&postcount=30), the latter of which looked pretty promising.

Unfortunately, despite the quite clean nature of the [resulting formula](http://latex.codecogs.com/png.download?%5Cbg_white%20P%28x%29%20%3D%20%5Cint_%7Bx-R%7D%5E%7Bx+R%7D2%5Cint_%7B0%7D%5E%7B%5Ctheta%28r%29%7Dp%28r%29%20r%20d%5Ctheta%20dr%20%3D%202%5Cint_%7Bx-R%7D%5E%7Bx+R%7D%5Cint_%7B0%7D%5E%7B%5Ctheta%28r%29%7D%5Cfrac%7Bp_0%7D%7Br%7D%20r%20d%5Ctheta%20dr%20%3D%20%5Cnewline%20%3D%202%20p_0%5Cint_%7Bx-R%7D%5E%7Bx+R%7D%5Cint_%7B0%7D%5E%7B%5Ctheta%28r%29%7D%20d%5Ctheta%20dr%20%3D%202%20p_0%5Cint_%7Bx-R%7D%5E%7Bx+R%7D%20%5Ctheta%28r%29%20dr%20%3D%20%5Cnewline%20%3D%202%20p_0%5Cint_%7Bx-R%7D%5E%7Bx+R%7D%20%5Carccos%20%5Cleft%28%5Cfrac%7Bx%5E2-R%5E2+%20r%5E2%7D%7B2%20x%20r%7D%20%5Cright%29%20dr), I couldn't find a computational engine that would solve/plot this.
So, I decided (and finally got around) to do(ing) it myself.

This repo contains both an explanatory sketch ("CartesianPolar") and the actual sketch that plots the probability distribution over the distance from CM by virtue of the devised formula ("Integration").
