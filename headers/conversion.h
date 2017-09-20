#ifndef TCONVERSION_H
#define TCONVERSION_H

#include <stdint.h>

double round_nplaces(double value, int to);
uint32_t convert_double_to_uint(double x, int decimal_places);
double convert_uint_to_double(uint32_t x, int decimal_places);

#endif // TCONVERSION_H
