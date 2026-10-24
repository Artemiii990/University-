// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library Events {
    event StudentRegistered(uint256 id);
    event StudentEnrolled(uint256 studentId, uint256 courseId);

    event CourseCreated(uint256 id);
    event StudentRemoved(uint256 studentId, uint256 courseId);
}
