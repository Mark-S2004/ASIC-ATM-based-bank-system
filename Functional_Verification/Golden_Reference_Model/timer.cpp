#include <iostream>
using namespace std;

extern "C"
{
    void timerGM(bool clk, bool rst, bool start, bool restart, unsigned int threshold, bool *timeout)
    {
        static unsigned int counter = 0;
        static bool prev_rst = false;
        if (!rst)
        {
            counter = 0;
            *timeout = false;
        }
        else if (start)
        {
            if (restart)
            {
                counter = 0;
            }
            else
            {
                counter = counter + 1;
            }
            if (counter == threshold)
            {
                *timeout = true;
                counter = 0;
            }
        }
        else
        {
            counter = 0;
        }
        prev_rst = rst;
    }
}