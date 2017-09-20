#include <math.h>

#include "headers/conversion.h"

double round_nplaces(double value, int to)
{
    double places = pow(10.0, to);
    return static_cast<double>(round(value * places) / places);
}

uint32_t convert_double_to_uint(double x, int decimal_places)
{
//   double dx = x < 0.0 ? -0.5 : 0.5;
//   return static_cast<uint>(x + dx);

    double d_x = round(x * pow(10.0, decimal_places));
    return static_cast<uint32_t>(d_x);
}

double convert_uint_to_double(uint32_t x, int decimal_places)
{
    double u_x = (static_cast<double>(x))/pow(10.0, decimal_places);
    return u_x;
}
