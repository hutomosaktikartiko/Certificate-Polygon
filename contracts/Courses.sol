// SPDX-License-Identifier: MIT
pragma solidity ^0.4.17;

contract Courses {
    address public ownerAddress;
    address[] public courses;

    function Courses() public {
        ownerAddress = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == ownerAddress);
        _;
    }

    function createCourse(
        string memory _title,
        string memory _agency
    ) public onlyOwner {
        // Create new course
        address _newCourse = new Course(
            _title,
            _agency,
            msg.sender
        );

        // Push new course address
        courses.push(_newCourse);
    }

    // Return [true] if courseAddress is valid
    // Return [false] if courseAddress not valid
    function checkCourseIsValid(
        address _courseAddress
    ) public view returns(bool) {
        for (uint256 _i = 0; _i < courses.length; _i++) {
            if (courses[_i] == _courseAddress) {
                return true;
            }
        }

        return false;
    }

    function getCourse() public view returns(address[]) {
        return courses;
    }
}

contract Course {
    string public title;
    string public agency;
    address public ownerAddress;

    function Course(
        string memory _title,
        string memory _agency,
        address _ownerAddress
    ) public {
        title = _title;
        agency = _agency;
        ownerAddress = _ownerAddress;
    }

    function getCourse() public view returns(string memory, string memory, address) {
        return(
            title,
            agency,
            ownerAddress
        );
    }
}