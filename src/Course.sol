// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Errors.sol";
import {Events} from "./Events.sol";
import {StudentLibrary} from "./Student.sol";

library CourseLibrary {
    struct Course {
        uint256 id;
        string title;
        string teacher;
        uint256 maxStudents;
        uint256[] studentIds;
    }

    function createCourse(
        mapping(uint256 => Course) storage courses,
        uint256 id,
        string calldata title,
        string calldata teacher,
        uint256 maxStudents
    ) internal {
        if (id == 0) revert InvalidId();
        if (courses[id].id != 0) revert CourseAlreadyExists();

        Course storage course = courses[id];
        course.id = id;
        course.title = title;
        course.teacher = teacher;
        course.maxStudents = maxStudents;

        emit Events.CourseCreated(id);
    }

    function getCourse(
        mapping(uint256 => Course) storage courses,
        uint256 courseId
    ) internal view returns (Course storage) {
        Course storage course = courses[courseId];
        if (course.id == 0) revert CourseNotFound();
        return course;
    }

    function changeTeacher(
        mapping(uint256 => Course) storage courses,
        uint256 courseId,
        string calldata newTeacher
    ) internal {
        Course storage course = courses[courseId];
        if (course.id == 0) revert CourseNotFound();
        course.teacher = newTeacher;
    }

    function addStudent(
        mapping(uint256 => StudentLibrary.Student) storage students,
        mapping(uint256 => Course) storage courses,
        uint256 studentId,
        uint256 courseId
    ) internal {
        if (students[studentId].id == 0) revert StudentNotFound();
        if (courses[courseId].id == 0) revert CourseNotFound();

        courses[courseId].studentIds.push(studentId);
    }

    function returnStudents(
        mapping(uint256 => Course) storage courses,
        uint256 courseId
    ) internal view returns (uint256[] memory) {
        return courses[courseId].studentIds;
    }

    function removeStudent(
        mapping(uint256 => Course) storage courses,
        uint256 courseId,
        uint256 studentId
    ) internal {
        uint256[] storage ids = courses[courseId].studentIds;

        for (uint256 i = 0; i < ids.length; i++) {
            if (ids[i] == studentId) {
                ids[i] = ids[ids.length - 1];
                ids.pop();
                break;
            }
        }

        emit Events.StudentRemoved(studentId, courseId);
    }
}
