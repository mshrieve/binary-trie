# eth_binary

two implementations of a trie in order to generate random numbers

suppose we want to generate all the numbers less than 2^32 in some, potentially random, order.

the trie structure is defined as follows.

at level 0, we have all the 2^32 values
at level 1, we have the prefixes obtained from bitshifting the values down by 1
al level i, we have the prefixes obtianed from bitshifting the values down by i

mapping(bytes32 => bool) marked;
indicates whether a (value, level) has available child nodes
(value, level) => marked[abi.encode(value, level)]

we need to include the data of the level to distinguish between a prefix and
values that happen to have zeroes in their most significant digits

to get the prefix of m, take m >> 1;
the children of m are m << 1, and m << 1 + 1

# trie 1

in trie 1, we input a number, moving up the trie from level 0 until we find
a node with available children, then move back down.
this is can be more efficient, especially if not many numbers have been issued,
but has a worst case of traversing all the way from the bottom to the top, and back again, and THEN we still have to start from the bottom again to mark the nodes.
trie 1 has a tendency to mint numbers that are adjacent to one another, given the same input, although this can be avoided by applying a nice 1-1 function to the output.

# trie 2

in trie 2, we start from the top of the trie and percolate down randomly through available nodes, marking the unavailable nodes after the recursive step returns.
trie 2 has a less variable efficiency (although not by much), and higher average gas cost.
