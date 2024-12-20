USE GymManagement
GO
/****** Object:  StoredProcedure [dbo].[AddNewClass]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Modified AddNewClass Procedure
CREATE PROCEDURE [dbo].[AddNewClass]
    @Name NVARCHAR(100),
    @Schedule NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO Classes (Name, Schedule, Gym_ID, Trainer_ID)
            VALUES (@Name, @Schedule, 1, 1); -- Set Gym_ID and Trainer_ID to 1 by default
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[AddNewEquipment]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Modified AddNewEquipment Procedure
CREATE PROCEDURE [dbo].[AddNewEquipment]
    @Equipment_Name NVARCHAR(100),
    @Maintenance_Date DATE,
    @Equipment_Type NVARCHAR(100),
    @Gym_ID INT = 1 -- Set default value of Gym_ID to 1
AS
BEGIN
    BEGIN TRY
        INSERT INTO Equipment (Name, Maintenance_Date, Equipment_Type, Gym_ID)
        VALUES (@Equipment_Name, @Maintenance_Date, @Equipment_Type, @Gym_ID);
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[AddNewMember]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddNewMember]
    @First_Name NVARCHAR(100),
    @Last_Name NVARCHAR(100),
    @Email NVARCHAR(255),
    @Phone NVARCHAR(15),
    @Membership_ID INT,
    @Join_Date DATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO Members (First_Name, Last_Name, Email, Phone, Membership_ID, Join_Date, Gym_ID)
            VALUES (@First_Name, @Last_Name, @Email, @Phone, @Membership_ID, @Join_Date, 1); -- Replace 1 with the default Gym_ID
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[AddNewStaff]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Modified AddNewStaff Procedure
CREATE PROCEDURE [dbo].[AddNewStaff]
    @Name NVARCHAR(100),
    @Phone NVARCHAR(15),
    @Salary DECIMAL(10, 2),
    @Staff_Role NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO Staff (Name, Phone, Salary, Staff_Role, Gym_ID)
            VALUES (@Name, @Phone, @Salary, @Staff_Role, 1); -- Set Gym_ID to 1 by default
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[AddNewTrainer]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Modified AddNewTrainer Procedure
CREATE PROCEDURE [dbo].[AddNewTrainer]
    @First_Name NVARCHAR(100),
    @Last_Name NVARCHAR(100),
    @Specialization NVARCHAR(100),
    @Phone NVARCHAR(15),
    @Salary DECIMAL(10, 2),
    @Gym_ID INT = 1 -- Set default value of Gym_ID to 1
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO Trainers (First_Name, Last_Name, Specialization, Phone, Salary, Gym_ID)
            VALUES (@First_Name, @Last_Name, @Specialization, @Phone, @Salary, @Gym_ID);
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[AllClasses]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AllClasses]
AS
BEGIN
    SELECT Class_ID, Name, Schedule , Gym_ID, Trainer_ID
    FROM Classes;
END 


GO
/****** Object:  StoredProcedure [dbo].[ALLEquipment]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ALLEquipment]
AS
BEGIN
    SELECT Equipment_ID, Name, Maintenance_Date, Equipment_Type, Gym_ID
    FROM Equipment;
END 


GO
/****** Object:  StoredProcedure [dbo].[AllMembers]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AllMembers]
AS
BEGIN
    SELECT Member_ID, Email, First_Name, Last_Name, Join_Date, Phone, Membership_ID, Gym_ID
    FROM Members;
END


GO
/****** Object:  StoredProcedure [dbo].[AllStaff]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AllStaff]
AS
BEGIN
    SELECT Staff_ID, Name, Phone, Salary, Staff_Role, Gym_ID
    FROM Staff;
END


GO
/****** Object:  StoredProcedure [dbo].[AllTrainers]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AllTrainers]
AS
BEGIN
    SELECT Trainer_ID, Specialization, First_Name, Last_Name, Phone, Salary, Gym_ID
    FROM Trainers;
END 


GO
/****** Object:  StoredProcedure [dbo].[AssignTrainerToClass]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 7. AssignTrainerToClass Procedure
CREATE PROCEDURE [dbo].[AssignTrainerToClass]
    @Trainer_ID INT,
    @Class_ID INT
AS
BEGIN
    BEGIN TRY
        -- Check if the Trainer exists in the Trainers table
        IF EXISTS (SELECT 1 FROM Trainers WHERE Trainer_ID = @Trainer_ID)
        BEGIN
            -- Proceed with the update if the Trainer exists
            UPDATE Classes
            SET Trainer_ID = @Trainer_ID
            WHERE Class_ID = @Class_ID;
        END
        ELSE
        BEGIN
            -- If the Trainer doesn't exist, print an error message
            PRINT 'Error: Trainer_ID does not exist in the Trainers table.';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[GetClassDetails]    Script Date: 12/20/2024 10:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 1. GetClassDetails Procedure
CREATE PROCEDURE [dbo].[GetClassDetails]
    @class_id INT
AS
BEGIN
    BEGIN TRY
        SELECT 
            Name AS class_name,
            Schedule AS class_type,
            Gym_ID AS gym_id,
            Trainer_ID AS trainer_id
        FROM Classes
        WHERE Class_ID = @class_id;
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[GetEquipmentDetails]    Script Date: 12/20/2024 10:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 1. GetEquipmentDetails Procedure
CREATE PROCEDURE [dbo].[GetEquipmentDetails]
    @equipment_id INT
AS
BEGIN
    BEGIN TRY
        SELECT 
            Name AS Equipment_Name,
            Maintenance_Date,
            Equipment_Type,
            Gym_ID
        FROM Equipment
        WHERE Equipment_ID = @equipment_id;
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[GetMemberDetails]    Script Date: 12/20/2024 10:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 1. GetMemberDetails Procedure
CREATE PROCEDURE [dbo].[GetMemberDetails]
    @member_id INT
AS
BEGIN
    BEGIN TRY
        -- Select the member's details based on the member_id
        SELECT 
            Member_ID,
            First_Name,
            Last_Name,
            Email,
            Phone,
            Join_Date,
            Membership_ID,
            Gym_ID
        FROM Members
        WHERE Member_ID = @member_id;
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[GetStaffDetails]    Script Date: 12/20/2024 10:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 3. GetStaffDetails Procedure
CREATE PROCEDURE [dbo].[GetStaffDetails]
    @staff_id INT
AS
BEGIN
    BEGIN TRY
        -- Query to return staff details
        SELECT 
            Name,
            Salary,
            Phone, 
            Staff_Role
        FROM Staff
        WHERE Staff_ID = @staff_id;
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[GetTrainerDetails]    Script Date: 12/20/2024 10:19:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 2. GetTrainerDetails Procedure
CREATE PROCEDURE [dbo].[GetTrainerDetails]
    @Trainer_id INT
AS
BEGIN
    BEGIN TRY
        SELECT 
            First_Name + ' ' + Last_Name AS Full_Name,
            Specialization,
            Phone, 
            Salary
        FROM Trainers
        WHERE Trainer_ID = @Trainer_id;
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;

GO
/****** Object:  StoredProcedure [dbo].[ScanMemberCard]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ScanMemberCard]
    @Member_ID INT
AS
BEGIN
    BEGIN TRY
        -- Begin transaction for data consistency
        BEGIN TRANSACTION;

        -- Step 1: Validate Member_ID and Membership_ID
        DECLARE @Membership_ID INT;
        SELECT @Membership_ID = Membership_ID
        FROM Members
        WHERE Member_ID = @Member_ID;

        IF @Membership_ID IS NULL
        BEGIN
            PRINT 'Invalid Member ID. Member does not exist.';
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Step 2: Check remaining days (sessions)
        DECLARE @RemainingDays INT;
        SELECT @RemainingDays = Duration_Days
        FROM Memberships
        WHERE Membership_ID = @Membership_ID;

        IF @RemainingDays IS NULL OR @RemainingDays <= 0
        BEGIN
            PRINT 'No remaining sessions (days) for this member.';
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Step 3: Deduct one day (session)
        UPDATE Memberships
        SET Duration_Days = Duration_Days - 1
        WHERE Membership_ID = @Membership_ID;

        -- Commit the transaction
        COMMIT TRANSACTION;
        PRINT 'One session (day) successfully deducted.';
    END TRY
    BEGIN CATCH
        -- Rollback in case of an error
        ROLLBACK TRANSACTION;
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;


GO
/****** Object:  StoredProcedure [dbo].[UpdateMemberInfo]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 5. UpdateMemberInfo Procedure
CREATE PROCEDURE [dbo].[UpdateMemberInfo]
    @Member_ID INT,
    @New_Email NVARCHAR(255),
    @New_Phone NVARCHAR(15)
AS
BEGIN
    BEGIN TRY
        UPDATE Members
        SET Email = @New_Email,
            Phone = @New_Phone
        WHERE Member_ID = @Member_ID;
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;


GO
/****** Object:  UserDefinedFunction [dbo].[CalculateGymProfit]    Script Date: 12/20/2024 7:55:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalculateGymProfit]()
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @totalMemberRevenue DECIMAL(10, 2);
    DECLARE @totalStaffSalary DECIMAL(10, 2);
    DECLARE @totalTrainerSalary DECIMAL(10, 2);
    DECLARE @totalProfit DECIMAL(10, 2);

    -- Calculate total revenue from members using correct price
    SELECT @totalMemberRevenue = SUM(Members.Membership_ID * Memberships.Price)
    FROM Members
    JOIN Memberships ON Members.Membership_ID = Memberships.Membership_ID
    WHERE Members.Gym_ID = 1;  -- Modify for the correct Gym_ID if needed

    -- Calculate total salary of staff
    SELECT @totalStaffSalary = SUM(Staff.Salary)
    FROM Staff
    WHERE Staff.Gym_ID = 1;  -- Modify for the correct Gym_ID if needed

    -- Calculate total salary of trainers
    SELECT @totalTrainerSalary = SUM(Trainers.Salary)
    FROM Trainers
    WHERE Trainers.Gym_ID = 1;  -- Modify for the correct Gym_ID if needed

    -- Calculate the profit (Revenue - Salaries)
    SET @totalProfit = @totalMemberRevenue - (@totalStaffSalary + @totalTrainerSalary);

    RETURN @totalProfit;
END;

GO
