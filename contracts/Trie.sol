// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Trie {
    uint256 depth = 5;
    uint256 max = 2**depth;

    mapping(bytes32 => bool) public trie;
    uint256 public issued;

    event Found(uint256 indexed m);

    constructor() {}

    function set(uint256 _m, uint256 _level) internal {
        trie[getKey(_m, _level)] = true;
    }

    // check if available
    function check(uint256 _m, uint256 _level) internal view returns (bool) {
        return !trie[getKey(_m, _level)];
    }

    function getKey(uint256 _m, uint256 _level)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(_m, _level));
    }

    function find(uint256 _m) public returns (uint256) {
        require(issued < max, 'no more numbers available');

        uint256 found;
        //  check
        if (check(_m, 0))
            found = _m;
            // ascend if unavailable
        else found = ascend(_m, 0);
        // mark edges as unavailable
        mark(found);
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

    // first ascend recursively
    // ascend FROM _m, _level
    function ascend(uint256 _m, uint256 _level) internal returns (uint256) {
        // _m was not available, check the sibling
        // flip the first bit
        uint256 m_ = _m ^ 1;
        // check at the same _level
        bool available = check(m_, _level);
        // if available, descent to the sibling
        if (available) return descend(m_, _level);
        // else, both leaves at _m are unavailable
        return ascend(_m >> 1, _level + 1);
    }

    // then descend recursively back to 0
    // descend TO _m, _level
    // one child has to be available
    function descend(uint256 _m, uint256 _level) internal returns (uint256) {
        if (_level == 0) return _m;
        // descend a level
        uint256 level = _level - 1;
        // add one bit
        uint256 m = _m << 1;
        // if L, add 0 and descend
        if (check(m, level)) return descend(m, level);
        // else, R must be available
        // and add 1
        return descend(m + 1, level);
    }
}
