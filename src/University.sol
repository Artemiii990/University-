// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Errors.sol";
import {Ownable} from "./Ownable.sol";
import {StudentLibrary} from "./Student.sol";
import {CourseLibrary} from "./Course.sol";

contract University is Ownable {
    mapping(uint256 => StudentLibrary.Student) public students;
    mapping(uint256 => CourseLibrary.Course) public courses;

    function registerStudent(
        uint256 id,
        string calldata name,
        uint256 age
    ) public onlyOwner {
        StudentLibrary.registerStudent(students, id, name, age);
    }

    function createCourse(
        uint256 id,
        string calldata title,
        string calldata teacher,
        uint256 maxStudents
    ) public onlyOwner {
        CourseLibrary.createCourse(courses, id, title, teacher, maxStudents);
    }

    function assignStudentToCourse(
        uint256 studentId,
        uint256 courseId
    ) public onlyOwner {
        StudentLibrary.addCourse(students, courses, studentId, courseId);
        CourseLibrary.addStudent(students, courses, studentId, courseId);
    }

    function unassignStudentFromCourse(
        uint256 studentId,
        uint256 courseId
    ) public onlyOwner {
        StudentLibrary.removeCourse(students, studentId, courseId);
        CourseLibrary.removeStudent(courses, courseId, studentId);
    }

    function getStudentCourses(
        uint256 studentId
    ) public view returns (uint256[] memory) {
        return StudentLibrary.returnCourses(students, studentId);
    }

    function getCourseStudents(
        uint256 courseId
    ) public view returns (uint256[] memory) {
        return CourseLibrary.returnStudents(courses, courseId);
    }
}
