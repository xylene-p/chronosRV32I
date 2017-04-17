import numpy as np
import random
from twobitstates import TBState

class Instruction:

    def __init__(self, addr):
        self.inst_addr = addr
        self.target

def two_bit_predict(history, init_state):
    curr_state = -1
    initialized = False
    history_arr = []
    history_len = 8
    count = 0
    while (history or (count < history_len)):
        history_bit = history % 2
        if (history != 0):
            history_arr.append(history_bit)
        else:
            history_arr.append(0)
        history = history >> 1
        count += 1
        if (initialized != True):
            if (init_state == -1):
                curr_state = TBState(random.randint(0, 3))
            else:
                if init_state == 0:
                    curr_state = TBState['S_NT']
                elif init_state == 1:
                    curr_state = TBState['W_NT']
                elif init_state == 2:
                    curr_state = TBState['W_T']
                elif init_state == 3:
                    curr_state = TBState['S_T']
            initialized = True

    while (history_arr):
        print("Current State: {}\tCurrent State Value: {}\t".format(curr_state, curr_state.value))
        next_state_bit = history_arr.pop()
        if (next_state_bit == 0):
            if (curr_state.value > 0):
                curr_state = TBState(curr_state.value - 1)
        elif (next_state_bit == 1):
            if (curr_state.value < 3):
                curr_state = TBState(curr_state.value + 1)
    print("Current State: {}\tCurrent State Value: {}\t".format(curr_state, curr_state.value))

    return curr_state


def Q(inst, state, action):
    pass

def main():
    # Generate random table of direction histories
    direction_table = np.random.randint(255, dtype=int, size=1000)
    num = random.randint(0, 254)
    history = direction_table[num]
    print("{:08b}".format(history))

    prediction = two_bit_predict(history, init_state=-1)


if __name__ == "__main__":
    main()
