// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// in trie2 we simply descend randomly from the top
contract Trie2 {
    uint256 depth = 5;
    uint256 max = 2**depth;

    mapping(bytes32 => bool) public trie;
    uint256 public issued;

    event Found(uint256 indexed m);

    // used within a transaction
    uint256 seed;

    constructor() {}

    function set(uint256 _m, uint256 _level) internal {
        //   (x => x | _leaf) sets the _leaf bit to 1
        // bytes32 key = getKey(_m >> 1, _level + 1);
        // bytes32 leaf = _m % 2 > 0 ? R : L;
        trie[getKey(_m, _level)] = true;
    }

    // check if available
    function check(uint256 _m, uint256 _level) internal view returns (bool) {
        //   (x => (x & _leaf) != 0 ) evaluates to true if the _leaf bit is NOT set
        return !trie[getKey(_m, _level)];
    }

    function getKey(uint256 _m, uint256 _level)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(_m, _level));
    }

    function find(uint256 _seed) public returns (uint256) {
        require(issued < max, 'no more numbers available');
        seed = _seed;
        // start at the top with 0
        (uint256 found, ) = descend(0, depth);
        // mark edges as unavailable
        emit Found(found);

        issued++;
        return found;
    }

    function mark(uint256 _m) internal {
        mark(_m, 0);
    }

    function mark(uint256 _m, uint256 _level) internal {
        set(_m, _level);
        if (check(_m ^ 1, _level))
            // if the other leaf is available, done
            return;
        // no leaves are available
        // if we are at the top of the tree
        if (_level == depth) return;
        //  otherwise, mark the parent edge
        mark(_m >> 1, _level + 1);
    }

    // descend recursively back to 0
    // descend TO _m, _level
    // one child has to be available
    // return the found number, as well as if the node resolves unavailable
    function descend(uint256 _m, uint256 _level)
        internal
        returns (uint256, bool)
    {
        if (_level == 0) return (_m, true);
        // descend a level
        uint256 level = _level - 1;
        // add one bit
        uint256 m = _m << 1;
        uint256 seed_ = seed >> _level;
        // {a,b} = {0,1}
        uint256 a = seed_ % 2;
        uint256 b = (seed_ + 1) % 2;

        if (check(m + a, level)) {
            (uint256 result, bool marked) = descend(m + a, level);
            if (!marked || check(m + b, level)) return (result, false);
            set(_m, _level);
            return (result, true);
        } else {
            (uint256 result, bool marked) = descend(m + b, level);
            if (!marked) return (result, false);
            set(_m, _level);
            return (result, true);
        }
    }
}
