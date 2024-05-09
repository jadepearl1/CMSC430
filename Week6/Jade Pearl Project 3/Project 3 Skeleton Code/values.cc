// CMSC 430 Compiler Theory and Design
// Project 3 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the bodies of the evaluation functions

#include <string>
#include <cmath>
#include <iostream>

using namespace std;

#include "values.h"
#include "listing.h"

double evaluateArithmetic(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
	case ADD:
		result = left + right;
		break;
	case SUBTRACT:
		result = left - right;
		break;
	case MULTIPLY:
		result = left * right;
		break;
	case DIVIDE:
		result = left / right;
		break;
	case MOD:
		if (right != 0)
			result = fmod(left, right);
		break;
	case EXPONENT:
		result = pow(left, right);
		break;
	case UNARY:
		result = -left;
		break;
	}
	return result;
}

double evaluateRelational(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
	case LESS:
		result = left < right;
		break;
	case GREAT:
		result = left > right;
		break;
	case EQUAL:
		result = left = right;
		break;
	case NOTEQUAL:
		result = left != right;
		break;
	case GEQUAL:
		result = left >= right;
		break;
	case LEQUAL:
		result = left <= right;
		break;
	}
	return result;
}

double fold(bool direction, Operators operator_, vector<double>* vals)
{
	if (vals == nullptr || vals->empty()) {
		return 0.0;
	}

	double result;

	if (direction) //Left fold
	{
		result = vals->front();
		for (size_t i = 1; i < vals->size(); ++i)
		{
			switch (operator_)
			{
			case ADD:
				result += (*vals)[i];
				break;
			case SUBTRACT:
				result -= (*vals)[i];
				break;
			case MULTIPLY:
				result *= (*vals)[i];
				break;
			case DIVIDE:
				result /= (*vals)[i];
				break;
			}
		}
	}
	else { //Right fold
		result = vals->back();
		for (size_t i = vals->size() - 1; i > 0; --i)
		{
			switch (operator_)
			{
			case ADD:
				result = (*vals)[i] + result;
				break;
			case SUBTRACT:
				result = (*vals)[i] - result;
				break;
			case MULTIPLY:
				result = (*vals)[i] * result;
				break;
			case DIVIDE:
				result = (*vals)[i] / result;
				break;
			}
		}
	}
	return result;
}