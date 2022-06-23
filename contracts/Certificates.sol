// SPDX-License-Identifier: MIT
pragma solidity ^0.4.17;

contract Certificates {
    address public ownerAddress;
    address[] public certificates;

    modifier onlyOwner() {
        require(msg.sender == ownerAddress);
        _;
    }

    event CreateCertificate(
        string _nik,
        address _certificateAddress,
        uint256 _expiredDate
    );

    function createCertificate(
        address _courseAddress,
        string memory _nik,
        uint256 _expiredDate,
        uint256 _score
    ) public {
        // Create new certificate
        address _newCertificate = new Certificate(
            msg.sender,
            _courseAddress,
            _nik,
            _expiredDate,
            _score
        );

        // Push new certificate address
        certificates.push(_newCertificate);

        // Emit CreateCertificate event
        CreateCertificate(
            _nik,
            _newCertificate,
            _expiredDate
        );
    }

    function checkCertificateIsValid(
        address _certificateAddress
    ) public view returns(bool) {
        for (uint256 _i = 0; _i < certificates.length; _i++) {
            if (certificates[_i] == _certificateAddress) {
                return true;
            }
        }

        return false;
    }

    function getCertificates() public view returns(address[]) {
        return certificates;
    }
}

contract Certificate {
    address public ownerAddress;
    address public courseAddress;
    string public nik;
    uint256 public expiredDate;
    uint256 public score;
    Log[] logs;

    struct Log {
        uint256 category;
        uint256 date;
    }
    
    modifier onlyOwner() {
        require(msg.sender == ownerAddress);
        _;
    }

    function Certificate(
        address _ownerAddress,
        address _courseAddress,
        string memory _nik,
        uint256 _expiredDate,
        uint256 _score
    ) public {
        // Set value
        ownerAddress = _ownerAddress;
        courseAddress = _courseAddress;
        nik = _nik;
        expiredDate = _expiredDate;
        score = _score;

        // Create new log
        Log memory _newLog = Log({
            category: 1,
            date: now
        });

        // Push new log
        logs.push(_newLog);
    }

    event ExtendExpiredDate (
        address _certificateAddress,
        address _courseAddress,
        uint256 _expiredDate
    );

    function extendCertificate(
        uint256 _newExpiredDate,
        uint256 _todayDate
    ) public onlyOwner {
        // Set new date
        expiredDate = _newExpiredDate;

        // Create new log
        Log memory _newLog = Log({
            category: 2,
            date: _todayDate
        });

        // Push new log
        logs.push(_newLog);

        // Emit event ExtendExpiredDate
        ExtendExpiredDate(
            address(this),
            courseAddress,
            expiredDate
        );
    }

    function getCertificate() public view returns(
        string memory,
        uint256,
        uint256,
        address
    ) {
        return(
            nik,
            expiredDate,
            score,
            courseAddress
        );
    }

    function getLogs() public view returns(
        uint256[] memory,
        uint256[] memory
    ) {
        uint256[] memory categoriesLog = new uint256[](
            logs.length
        );
        uint256[] memory datesLog = new uint256[](
            logs.length
        );

        for (uint256 _i = 0; _i < logs.length; _i++) {
            categoriesLog[_i] = logs[_i].category;
            datesLog[_i] = logs[_i].date;
        }

        return(
            categoriesLog,
            datesLog    
        );
    }
}