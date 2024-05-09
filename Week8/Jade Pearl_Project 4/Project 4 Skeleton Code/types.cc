// CMSC 430 Compiler Theory and Design
// Project 4 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the bodies of the type checking functions

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message) {
	if ((lValue == INT_TYPE && rValue == REAL_TYPE) || (lValue == REAL_TYPE && rValue == INT_TYPE))
		appendError(GENERAL_SEMANTIC, " Illegal Narrowing " + message);
	else if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
}

Types checkList(Types left, Types right) {
	if (left == INT_TYPE && right == INT_TYPE)
		return INT_TYPE;
	if (left == CHAR_TYPE && right == CHAR_TYPE)
		return CHAR_TYPE;
	if (left == REAL_TYPE && right == REAL_TYPE)
		return REAL_TYPE;
	appendError(GENERAL_SEMANTIC, "List Element Types Do Not Match");
	return MISMATCH;
}

void listVsElements(Types elems, Types list) {
	if (list != MISMATCH && elems != MISMATCH && list != elems)
		appendError(GENERAL_SEMANTIC, "List Type Does Not Match Element Types");
}

void checkSubscript(Types right) {
	if (right != INT_TYPE)
		appendError(GENERAL_SEMANTIC, "List Subscript Must Be Integer");
}

Types compareChars(Types left, Types right) {
	if (left == CHAR_TYPE && right == CHAR_TYPE)
		return CHAR_TYPE;
	if (left == CHAR_TYPE || right == CHAR_TYPE) // Modify this condition
		appendError(GENERAL_SEMANTIC, "Character Literals Cannot be Compared to Numeric Expressions");
	return MISMATCH;
}

Types checkWhen(Types true_, Types false_) {
	if (true_ == MISMATCH || false_ == MISMATCH)
		return MISMATCH;
	if (true_ != false_)
		appendError(GENERAL_SEMANTIC, "When Types Mismatch ");
	return true_;
}

Types checkSwitch(Types case_, Types when, Types other) {
	if (case_ != INT_TYPE)
		appendError(GENERAL_SEMANTIC, "Switch Expression Not Integer");
	return checkCases(when, other);
}

Types checkCases(Types left, Types right) {
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == NONE || left == right)
		return right;
	appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
	return MISMATCH;
}

Types checkArithmetic(Types left, Types right) {
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == INT_TYPE && right == INT_TYPE)
		return INT_TYPE;
	if ((left == INT_TYPE && right == REAL_TYPE) || (left == REAL_TYPE && right == INT_TYPE))
		return REAL_TYPE;
	appendError(GENERAL_SEMANTIC, "Integer Type Required");
	return MISMATCH;
}

void checkUnaryExpo(Types num) {
	if (num != INT_TYPE || num != REAL_TYPE)
		appendError(GENERAL_SEMANTIC, "Arithmetic Operator Requires Numeric Types");
}

Types handleUnaryNegation(Types operand) {
    if (operand == INT_TYPE || operand == REAL_TYPE || operand == CHAR_TYPE) {
        // Unary negation is valid for integer, real, and character types
        return operand;
    } else {
        return MISMATCH;
    }
}

Types checkMod(Types left, Types right) {
	if(left == INT_TYPE && right == INT_TYPE)
		return INT_TYPE;
	appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operands");
	return MISMATCH;
}

Types ifStatement(Types left, Types elsif, Types els) {
	if(left == elsif && elsif == els)
        return left;
    appendError(GENERAL_SEMANTIC, " If-Elsif-Else Type Mismatch");
    return MISMATCH;
}

void checkFold(Types list) {
	if (list != INT_TYPE && list != REAL_TYPE)
		appendError(GENERAL_SEMANTIC, "Fold Requires a Numeric List");
}