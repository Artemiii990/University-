// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Errors.sol";
import {Events} from "./Events.sol";
import {CourseLibrary} from "./Course.sol";

library StudentLibrary {
    struct Student {
        uint256 id;
        string name;
        uint256 age;
        bool active;
        uint256[] courseIds;
    }

    function registerStudent(
        mapping(uint256 => Student) storage students,
        uint256 id,
        string calldata name,
        uint256 age
    ) internal {
        if (id == 0) revert InvalidId();
        if (students[id].id != 0) revert StudentAlreadyExists();

        Student storage student = students[id];
        student.id = id;
        student.name = name;
        student.age = age;
        student.active = true;

        emit Events.StudentRegistered(id);
    }

    function getStudent(
        mapping(uint256 => Student) storage students,
        uint256 studentId
    ) internal view returns (Student storage) {
        Student storage student = students[studentId];
        if (student.id == 0) revert StudentNotFound();
        return student;
    }

    function deactivateStudent(
        mapping(uint256 => Student) storage students,
        uint256 studentId
    ) internal {
        Student storage student = students[studentId];
        if (student.id == 0) revert StudentNotFound();
        student.active = false;
    }

    function addCourse(
        mapping(uint256 => Student) storage students,
        mapping(uint256 => CourseLibrary.Course) storage courses,
        uint256 studentId,
        uint256 courseId
    ) internal {
        if (students[studentId].id == 0) revert StudentNotFound();
        if (courses[courseId].id == 0) revert CourseNotFound();

        students[studentId].courseIds.push(courseId);
        emit Events.StudentEnrolled(studentId, courseId);
    }

    function returnCourses(
        mapping(uint256 => Student) storage students,
        uint256 studentId
    ) internal view returns (uint256[] memory) {
        return students[studentId].courseIds;
    }

    function removeCourse(
        mapping(uint256 => Student) storage students,
        uint256 studentId,
        uint256 courseId
    ) internal {
        uint256[] storage ids = students[studentId].courseIds;

        for (uint256 i = 0; i < ids.length; i++) {
            if (ids[i] == courseId) {
                ids[i] = ids[ids.length - 1];
                ids.pop();
                break;
            }
        }
    }
}
