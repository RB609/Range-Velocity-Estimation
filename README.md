# Range and velocity estimation
This project uses data obtained from an underwater radar system to plot out the range and velocity profile of the target, a pendulum in this case.

For data acquisition, a pair of ultrasonic transducers (1-5 MHz) were used as transmitter and reciever. Linear chirp pulses (1.5-4.5 MHz) were used to illuminate the target. The code takes this data as input and plots out the range and velocity profile of the pendulum.

Two signal processing algorithms: correlation processing, and end point detection have been used for this purpose.

The algorithms were also analysed for noisy environments with pre-filtering by adding AWGN to the input signals.

The results are compiled in report.pdf
