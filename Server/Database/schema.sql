USE GymManagement;
CREATE TABLE Gym (
    Gym_ID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment Gym_ID
    Location VARCHAR(50),
    Name VARCHAR(100),
    Capacity INT,
    Contact VARCHAR(20)
);

CREATE TABLE Staff (
    Staff_ID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment Staff_ID
    Name VARCHAR(100),
    Phone VARCHAR(15),
    Salary DECIMAL(10, 2),
    Staff_Role VARCHAR(100),
    Gym_ID INT, 
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID)
);

CREATE TABLE Trainers (
    Trainer_ID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment Trainer_ID
    Specialization VARCHAR(100),
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Phone VARCHAR(15),
    Salary DECIMAL(10, 2),
    Gym_ID INT,
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID)
);

CREATE TABLE Equipment (
    Equipment_ID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment Equipment_ID
    Name VARCHAR(100),
    Maintenance_Date DATE,
    Equipment_Type VARCHAR(100),
    Gym_ID INT, 
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID)
);

CREATE TABLE Memberships (
    Membership_ID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment Membership_ID
    Price INT,
	Membership_Type VARCHAR(100),
    Duration_Days INT
);

CREATE TABLE Members (
    Member_ID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment Member_ID
    Email VARCHAR(50),
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Join_Date DATE,
    Phone VARCHAR(15),
    Membership_ID INT,
    Gym_ID INT,
    FOREIGN KEY (Membership_ID) REFERENCES Memberships(Membership_ID),
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID)
);

CREATE TABLE Activities (
    Activity_ID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment Activity_ID
    Name VARCHAR(50),
    Duration_Minutes INT,
    Description VARCHAR(100)
);

CREATE TABLE Classes (
    Class_ID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment Class_ID
    Name VARCHAR(100),
    Schedule VARCHAR(100),
    Gym_ID INT,
    Trainer_ID INT, 
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID),
    FOREIGN KEY (Trainer_ID) REFERENCES Trainers(Trainer_ID)
);

CREATE TABLE Personal_Trainings (
    Training_ID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment Training_ID
    Duration_Minutes INT,
    Start_Time DATETIME,  -- Changed from TIMESTAMP to DATETIME
    Type VARCHAR(100),
    Gym_ID INT, 
    Member_ID INT,
    Trainer_ID INT, 
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID),
    FOREIGN KEY (Trainer_ID) REFERENCES Trainers(Trainer_ID),
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID)
);

CREATE TABLE Payments (
    Payment_ID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment Payment_ID
    Method VARCHAR(50),
    Amount DECIMAL(10, 2),
    Date DATE,
    Member_ID INT,
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID)
);

CREATE TABLE Events (
    Event_ID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment Event_ID
    Name VARCHAR(50),
    Location VARCHAR(100),
    Description VARCHAR(100),
    Date DATE,
    Staff_ID INT,
    Trainer_ID INT,
    FOREIGN KEY (Trainer_ID) REFERENCES Trainers(Trainer_ID),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID)
);

CREATE TABLE Member_Activity (
    Member_ID INT,
    Activity_ID INT,
    Participation_Type VARCHAR(50),
    PRIMARY KEY (Member_ID, Activity_ID),
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID),
    FOREIGN KEY (Activity_ID) REFERENCES Activities(Activity_ID)
);

CREATE TABLE Member_Class (
    Member_ID INT,
    Class_ID INT,
    Enrollment_Date DATE,
    PRIMARY KEY (Member_ID, Class_ID),
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID),
    FOREIGN KEY (Class_ID) REFERENCES Classes(Class_ID)
);