// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LearnToEarn {
    // Struct to represent a course
    struct Course {
        uint256 id;
        string name;
        uint256 reward;
        address creator;
        bool isActive;
    }

    // Struct to represent a learner
    struct Learner {
        uint256 completedCourses;
        uint256 totalRewards;
    }

    // Mappings
    mapping(uint256 => Course) public courses;
    mapping(address => Learner) public learners;
    mapping(address => mapping(uint256 => bool)) public courseCompletion;

    // State variables
    uint256 public nextCourseId;
    address public owner;

    // Events
    event CourseCreated(uint256 id, string name, uint256 reward, address creator);
    event CourseCompleted(address learner, uint256 courseId, uint256 reward);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier courseExists(uint256 courseId) {
        require(courses[courseId].isActive, "Course does not exist or is inactive");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to create a new course
    function createCourse(string memory name, uint256 reward) external onlyOwner {
        require(reward > 0, "Reward must be greater than zero");
        courses[nextCourseId] = Course(nextCourseId, name, reward, msg.sender, true);
        emit CourseCreated(nextCourseId, name, reward, msg.sender);
        nextCourseId++;
    }

    // Function for a learner to complete a course
    function completeCourse(uint256 courseId) external courseExists(courseId) {
        require(!courseCompletion[msg.sender][courseId], "Course already completed");

        courseCompletion[msg.sender][courseId] = true;
        learners[msg.sender].completedCourses++;
        learners[msg.sender].totalRewards += courses[courseId].reward;

        emit CourseCompleted(msg.sender, courseId, courses[courseId].reward);
    }

    // Function to deactivate a course
    function deactivateCourse(uint256 courseId) external onlyOwner courseExists(courseId) {
        courses[courseId].isActive = false;
    }

    // Function to get course details
    function getCourse(uint256 courseId) external view returns (Course memory) {
        return courses[courseId];
    }

    // Function to get learner details
    function getLearner(address learner) external view returns (Learner memory) {
        return learners[learner];
    }
}
