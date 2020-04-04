
CREATE TABLE Person (
        username VARCHAR(32),
        password VARCHAR(64),
        firstName VARCHAR(32),
        lastName VARCHAR(32),
        email VARCHAR(32),
        PRIMARY KEY (username)
);



CREATE TABLE Photo (
        pID INT AUTO_INCREMENT,
        postingDate DATETIME,
        filePath VARCHAR(255), -- you may replace this by a BLOB attribute to store the actual photo
        allFollowers INT,
        caption VARCHAR(1000),
        poster VARCHAR(32),
        PRIMARY KEY (pID),
        FOREIGN KEY (poster) REFERENCES Person (username)
);

CREATE TABLE block(
        blocker VARCHAR(32),
        blockee VARCHAR(32),
        PRIMARY KEY (blocker,blockee),
        FOREIGN KEY (blocker) REFERENCES Person (username),
        FOREIGN KEY (blockee) REFERENCES Person (username)
)

CREATE TABLE FriendGroup (
        groupName VARCHAR(32),
        groupCreator VARCHAR(32),
        description VARCHAR(1000),
        PRIMARY KEY (groupName, groupCreator),
        FOREIGN KEY (groupCreator) REFERENCES Person (username)
);

CREATE TABLE ReactTo (
        username VARCHAR(32),
        pID INT,
        reactionTime DATETIME,
        comment VARCHAR(1000),
        emoji VARCHAR(32), -- you may replace this by a BLOB or fileName of a jpg or some such
	PRIMARY KEY (username, pID),
        FOREIGN KEY (pID) REFERENCES Photo (pID),
        FOREIGN KEY (username) REFERENCES Person (username)
);

CREATE TABLE Tag (
        pID INT,
        username VARCHAR(32),
        tagStatus INT,
	PRIMARY KEY (pID, username),
        FOREIGN KEY (pID) REFERENCES Photo (pID),
        FOREIGN KEY (username) REFERENCES Person (username)
);


CREATE TABLE SharedWith (
        pID INT,
        groupName VARCHAR(32),
        groupCreator VARCHAR(32),
	PRIMARY KEY (pID, groupName, groupCreator),
	FOREIGN KEY (groupName, groupCreator) REFERENCES FriendGroup(groupName, groupCreator),
        FOREIGN KEY (pID) REFERENCES Photo (pID)
);



CREATE TABLE BelongTo (
        username VARCHAR(32),
        groupName VARCHAR(32),
	groupCreator VARCHAR(32),
        PRIMARY KEY (username, groupName, groupCreator),
        FOREIGN KEY (username) REFERENCES Person (username),
        FOREIGN KEY (groupName, groupCreator) REFERENCES FriendGroup (groupName, groupCreator)
);

CREATE TABLE Follow (
        follower VARCHAR(32),
        followee VARCHAR(32),
        followStatus INT,
        PRIMARY KEY (follower, followee),
        FOREIGN KEY (follower) REFERENCES Person (username),
        FOREIGN KEY (followee) REFERENCES Person (username)
);

INSERT INTO `follow` (`follower`, `followee`, `followStatus`) VALUES
('hz1704', 'yl5680', 1),
('yl5680', 'hz1704', 1),
('francmeister', 'hz1704', 1),
('francmeister', 'sl1234', 1),
('francmeister', 'yl5680', 0);

INSERT INTO `friendgroup` (`groupName`, `groupCreator`, `description`) VALUES
('eagle', 'sl1234', 'cyka');

INSERT INTO `person` (`username`, `password`, `firstName`, `lastName`, `email`) VALUES
('hz1704', 'blyat', 'HN', 'Z', 'hz1704@nyu.edu'),
('yl5680', 'cyka', 'YC', 'L', 'yl5680'),
('sl1234', 'ccc', 'SC', 'L', 'sl1234@nyu.edu'),
('francmeister', '123', 'franc', 'meister', 'fm123');

INSERT INTO `photo` (`pID`, `postingDate`, `filePath`, `allFollowers`, `caption`, `poster`) VALUES
(1, '2020-03-25 00:00:00', '111', 1, 'cyka', 'yl5680'),
(2, '2020-03-10 00:00:00', '1111', 1, 'asdfasdfa', 'sl1234'),
(7, '2020-03-31 20:59:08', 'c:\\\\guishi123123123', 1, 'asdfasdfa', 'hz1704'),
(4, '2020-03-31 16:20:15', 'c:\\\\guishi123', 1, 'shenmolian123', 'abc'),
(5, '2020-03-31 20:40:12', 'c:\\\\guishi12345', 1, 'shentouguilian', 'hz1704'),
(6, '2020-03-31 20:42:32', 'c:\\\\777', 1, 'clearlove', 'hz1704');

INSERT INTO `sharedwith` (`pID`, `groupName`, `groupCreator`) VALUES
(2, 'eagle', 'sl1234');