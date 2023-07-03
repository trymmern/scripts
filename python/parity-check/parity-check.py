import numpy as np
import operator as op
from functools import reduce

bits = np.random.randint(0, 2, 16)

bit = reduce(op.xor, [i for i, bit in enumerate(bits) if bit])


bits[10] = not bits[10]

print(bit);