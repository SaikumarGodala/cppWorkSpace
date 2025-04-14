#pragma once

void raceCondition(int threadIdentifier, int* shared_array);
void safeThreadAccess(int threadIdentifier, int* shared_array);
void deadlock();

