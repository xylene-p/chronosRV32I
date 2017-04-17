from enum import Enum

# Two Bit States
# S_NT -> strongly not taken
# W_NT -> weakly not taken
# W_T  -> weakly taken
# S_T  -> strongly taken
class TBState(Enum):
    S_NT = 0
    W_NT = 1
    W_T = 2
    S_T = 3
