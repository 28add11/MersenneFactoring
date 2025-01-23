# 28add11's Mersenne prime trial factoring ASIC prototype
This is a proof of concept for a [Mersenne prime trial factoring](https://www.mersenne.org/various/math.php#trial_factoring) ASIC/FPGA.
VERY work-in-progress, and doesn't have many particular uses currently, but hopefully that will change in the future!

## What does it do?
Currently, it is just a somewhat simple implementation of the algorithm on [the GIMPS website](https://www.mersenne.org/various/math.php#trial_factoring) in Verilog. Given an exponent `p` and a divisor `d` it will try to divide 2^p - 1 by d, and set the `dividesBy` reg accordingly.
I highly reccomend not using this for any real projects, as I have not fully verified that it works across many primes, which is a crucial part of GIMPS to avoid wasting other people's time and energy. However, I'm hoping to improve it in the future, maybe even to a production ready state!
Currently though, it does work, and is a solid base to expand upon. I also learned a lot while making it, both for digital design and math. 
It is comprised of a dedicated squaring unit, which makes use of some nice properties of binary squaring, and a divider, which was entirely custom and a great way to learn.
These components are then all brought together and used to actually calculate if the potential prime can be factored, all using a design which can hopefully be used in real hardware!

## Future goals
Eventually I want to get this project running on a real FPGA or potentially even taped out if there is enough interest, but first, I have some goals for improvements to make it significantly better.
1. Clean up squaring module and how modules are laied out to reduce latency
   - Currently, the squaring module is a bit of a mess, and doesn't map well in my head to an actual circuit. This is potentially a problem for expanding it and adjusting functionality (such as adding the other ideas in this list!)
   - The modules are also currently laied out and interlinked poorly. While this doesn't change functionality, it adds additional latency that I would really like to reduce for a production product
2. Improve the division algorithm used
   - The current division algorithm is not terrifically fast, but works decently well and shouldn't take up too much area on an actual product.
   - This can be improved though, algorithms such as SRT division can greatly speed up the process, and there are even more methods such as Barret reduction that could help even more.
3. Expand for arbitrary bit widths
   - GIMPS deals with huge primes and exponents ([as a matter of fact, the biggest primes ever discovered](https://www.mersenne.org/primes/?press=M136279841)) which means bit widths can get huge, fast. Currently, the implementation only supports static bit widths.
   - If this can be changed to an arbitrary bit width approach, it would make it significantly more practical for real prime hunting, not to mention involve some super cool algorithms.
4. Make the design more parallel
   - GPUs are so good at this task because of their many cores, and there's definitly an advantage to implementing a parallel version of this design to factor many primes all at once.
5. Implement it on an actual SoC
   - If this design is implemented on an actual SoC, it could be flexible enough to well and truly hunt prime numbers.
   - This is quite the undertaking, but is hopefully doable. If I accomplished this, I feel that the project would be truly complete and ready to become a real product.

## How to test
Since this is currently just Verilog, you will need a simulator and a waveform viewer. I used cocotb to run the tests, all on Tiny Tapeout's test stack, which has instructions [here](https://tinytapeout.com/hdl/testing/). I used GTKwave to view the waveforms.
