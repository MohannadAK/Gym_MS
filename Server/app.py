from flask import Flask, request, jsonify
import pyodbc

app = Flask(__name__)

# Database connection settings
db_config = {
    'server': '.',
    'database': 'GymManagement'
}

def get_db_connection():
    connection_string = (
        f"DRIVER={{SQL Server}};"
        f"SERVER={db_config['server']};"
        f"DATABASE={db_config['database']};"
        "Trusted_Connection=yes;"
    )
    conn = pyodbc.connect(connection_string)
    return conn

@app.route('/api/add_class', methods=['POST'])
def add_class():
    """API endpoint to add a new class by calling the stored procedure."""
    try:
        # Get data from request
        data = request.get_json()
        name = data.get('name')
        schedule = data.get('schedule')

        if not name or not schedule:
            return jsonify({'error': 'Name and Schedule are required.'}), 400

        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Execute the stored procedure
        cursor.execute("EXEC [dbo].[AddNewClass] @Name = ?, @Schedule = ?", name, schedule)
        conn.commit()

        return jsonify({'message': 'Class added successfully.'}), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        # Close the database connection
        cursor.close()
        conn.close()


@app.route('/api/add_equipment', methods=['POST'])
def add_equipment():
    """API endpoint to add new equipment by calling the stored procedure."""
    try:
        # Get data from request
        data = request.get_json()
        equipment_name = data.get('equipment_name')
        maintenance_date = data.get('maintenance_date')
        equipment_type = data.get('equipment_type')
        gym_id = data.get('gym_id', 1)  # Default Gym_ID to 1 if not provided

        if not equipment_name or not maintenance_date or not equipment_type:
            return jsonify({'error': 'Equipment name, maintenance date, and type are required.'}), 400

        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Execute the stored procedure
        cursor.execute("EXEC [dbo].[AddNewEquipment] @Equipment_Name = ?, @Maintenance_Date = ?, @Equipment_Type = ?, @Gym_ID = ?",
                       equipment_name, maintenance_date, equipment_type, gym_id)
        conn.commit()

        return jsonify({'message': 'Equipment added successfully.'}), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        # Close the database connection
        cursor.close()
        conn.close()

@app.route('/api/add_member', methods=['POST'])
def add_member():
    """API endpoint to add a new member by calling the stored procedure."""
    try:
        # Get data from request
        data = request.get_json()
        first_name = data.get('first_name')
        last_name = data.get('last_name')
        email = data.get('email')
        phone = data.get('phone')
        membership_id = data.get('membership_id')
        join_date = data.get('join_date')

        if not all([first_name, last_name, email, phone, membership_id, join_date]):
            return jsonify({'error': 'All member fields are required.'}), 400

        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Execute the stored procedure
        cursor.execute(
            "EXEC [dbo].[AddNewMember] @First_Name = ?, @Last_Name = ?, @Email = ?, @Phone = ?, @Membership_ID = ?, @Join_Date = ?",
            first_name, last_name, email, phone, membership_id, join_date
        )
        conn.commit()

        return jsonify({'message': 'Member added successfully.'}), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        # Close the database connection
        cursor.close()
        conn.close()

@app.route('/api/add_staff', methods=['POST'])
def add_staff():
    """API endpoint to add new staff by calling the stored procedure."""
    try:
        # Get data from request
        data = request.get_json()
        name = data.get('name')
        phone = data.get('phone')
        salary = data.get('salary')
        staff_role = data.get('staff_role')

        if not all([name, phone, salary, staff_role]):
            return jsonify({'error': 'Name, phone, salary, and staff role are required.'}), 400

        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Execute the stored procedure
        cursor.execute(
            "EXEC [dbo].[AddNewStaff] @Name = ?, @Phone = ?, @Salary = ?, @Staff_Role = ?",
            name, phone, salary, staff_role
        )
        conn.commit()

        return jsonify({'message': 'Staff added successfully.'}), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        # Close the database connection
        cursor.close()
        conn.close()

@app.route('/api/add_trainer', methods=['POST'])
def add_trainer():
    """API endpoint to add a new trainer by calling the stored procedure."""
    try:
        data = request.get_json()
        first_name = data.get('first_name')
        last_name = data.get('last_name')
        specialization = data.get('specialization')
        phone = data.get('phone')
        salary = data.get('salary')
        gym_id = data.get('gym_id', 1)

        if not all([first_name, last_name, specialization, phone, salary]):
            return jsonify({'error': 'All trainer fields are required.'}), 400

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC [dbo].[AddNewTrainer] @First_Name = ?, @Last_Name = ?, @Specialization = ?, @Phone = ?, @Salary = ?, @Gym_ID = ?",
            first_name, last_name, specialization, phone, salary, gym_id
        )
        conn.commit()

        return jsonify({'message': 'Trainer added successfully.'}), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/all_classes', methods=['GET'])
def all_classes():
    """API endpoint to fetch all classes."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("EXEC [dbo].[AllClasses]")
        classes = cursor.fetchall()

        result = [
            {
                'Class_ID': row.Class_ID,
                'Name': row.Name,
                'Schedule': row.Schedule,
                'Gym_ID': row.Gym_ID,
                'Trainer_ID': row.Trainer_ID
            }
            for row in classes
        ]

        return jsonify(result), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/all_equipment', methods=['GET'])
def all_equipment():
    """API endpoint to fetch all equipment."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("EXEC [dbo].[ALLEquipment]")
        equipment = cursor.fetchall()

        result = [
            {
                'Equipment_ID': row.Equipment_ID,
                'Name': row.Name,
                'Maintenance_Date': row.Maintenance_Date,
                'Equipment_Type': row.Equipment_Type,
                'Gym_ID': row.Gym_ID
            }
            for row in equipment
        ]

        return jsonify(result), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/all_members', methods=['GET'])
def all_members():
    """API endpoint to fetch all members."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("EXEC [dbo].[AllMembers]")
        members = cursor.fetchall()

        result = [
            {
                'Member_ID': row.Member_ID,
                'Email': row.Email,
                'First_Name': row.First_Name,
                'Last_Name': row.Last_Name,
                'Join_Date': row.Join_Date,
                'Phone': row.Phone,
                'Membership_ID': row.Membership_ID,
                'Gym_ID': row.Gym_ID
            }
            for row in members
        ]

        return jsonify(result), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/all_staff', methods=['GET'])
def get_all_staff():
    """API endpoint to retrieve all staff members by calling the stored procedure."""
    try:
        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Execute the stored procedure
        cursor.execute("EXEC [dbo].[AllStaff]")
        staff_records = cursor.fetchall()

        # Convert records to JSON format
        staff_list = [
            {
                'Staff_ID': row[0],
                'Name': row[1],
                'Phone': row[2],
                'Salary': row[3],
                'Staff_Role': row[4],
                'Gym_ID': row[5]
            }
            for row in staff_records
        ]

        return jsonify(staff_list), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/all_trainers', methods=['GET'])
def get_all_trainers():
    """API endpoint to retrieve all trainers by calling the stored procedure."""
    try:
        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Execute the stored procedure
        cursor.execute("EXEC [dbo].[AllTrainers]")
        trainer_records = cursor.fetchall()

        # Convert records to JSON format
        trainer_list = [
            {
                'Trainer_ID': row[0],
                'Specialization': row[1],
                'First_Name': row[2],
                'Last_Name': row[3],
                'Phone': row[4],
                'Salary': row[5],
                'Gym_ID': row[6]
            }
            for row in trainer_records
        ]

        return jsonify(trainer_list), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/assign_trainer_to_class', methods=['POST'])
def assign_trainer_to_class():
    """API endpoint to assign a trainer to a class by calling the stored procedure."""
    try:
        # Get data from request
        data = request.get_json()
        trainer_id = data.get('trainer_id')
        class_id = data.get('class_id')

        if not trainer_id or not class_id:
            return jsonify({'error': 'Trainer_ID and Class_ID are required.'}), 400

        # Connect to the database
        conn = get_db_connection()
        cursor = conn.cursor()

        # Execute the stored procedure
        cursor.execute(
            "EXEC [dbo].[AssignTrainerToClass] @Trainer_ID = ?, @Class_ID = ?",
            trainer_id, class_id
        )
        conn.commit()

        return jsonify({'message': 'Trainer assigned to class successfully.'}), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/get_class_details/<int:class_id>', methods=['GET'])
def get_class_details(class_id):
    """API endpoint to get class details by class_id."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC [dbo].[GetClassDetails] @class_id = ?", class_id
        )
        output_params = cursor.fetchone()

        if not output_params:
            return jsonify({'error': 'Class not found.'}), 404

        response = {
            'class_name': output_params[0],
            'class_type': output_params[1],
            'gym_id': output_params[2],
            'trainer_id': output_params[3]
        }
        return jsonify(response), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/get_equipment_details/<int:equipment_id>', methods=['GET'])
def get_equipment_details(equipment_id):
    """API endpoint to get equipment details by equipment_id."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC [dbo].[GetEquipmentDetails] @equipment_id = ?", equipment_id
        )
        output_params = cursor.fetchone()

        if not output_params:
            return jsonify({'error': 'Equipment not found.'}), 404

        response = {
            'equipment_name': output_params[0],
            'maintenance_date': output_params[1],
            'equipment_type': output_params[2],
            'gym_id': output_params[3]
        }
        return jsonify(response), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/get_member_details/<int:member_id>', methods=['GET'])
def get_member_details(member_id):
    """API endpoint to get member details by member_id."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC [dbo].[GetMemberDetails] @member_id = ?", member_id
        )
        output_params = cursor.fetchone()

        if not output_params:
            return jsonify({'error': 'Member not found.'}), 404

        response = {
            'member_id': output_params[0],
            'first_name': output_params[1],
            'last_name': output_params[2],
            'email': output_params[3],
            'phone': output_params[4],
            'join_date': output_params[5],
            'membership_id': output_params[6],
            'gym_id': output_params[7]
        }
        return jsonify(response), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/get_staff_details/<int:staff_id>', methods=['GET'])
def get_staff_details(staff_id):
    """API endpoint to get staff details by staff_id."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC [dbo].[GetStaffDetails] @staff_id = ?", staff_id
        )
        output_params = cursor.fetchone()

        if not output_params:
            return jsonify({'error': 'Staff not found.'}), 404

        response = {
            'name': output_params[0],
            'salary': output_params[1],
            'phone': output_params[2],
            'staff_role': output_params[3]
        }
        return jsonify(response), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/get_trainer_details/<int:trainer_id>', methods=['GET'])
def get_trainer_details(trainer_id):
    """API endpoint to get trainer details by trainer_id."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC [dbo].[GetTrainerDetails] @Trainer_id = ?", trainer_id
        )
        output_params = cursor.fetchone()

        if not output_params:
            return jsonify({'error': 'Trainer not found.'}), 404

        response = {
            'full_name': output_params[0],
            'specialization': output_params[1],
            'phone': output_params[2],
            'salary': output_params[3]
        }
        return jsonify(response), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@app.route('/api/scan_member_card', methods=['POST'])
def scan_member_card():
    """API endpoint to scan a member's card and deduct a session/day."""
    try:
        data = request.get_json()
        member_id = data.get('member_id')

        if not member_id:
            return jsonify({'error': 'Member ID is required.'}), 400

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("EXEC [dbo].[ScanMemberCard] @Member_ID = ?", member_id)
        conn.commit()

        return jsonify({'message': 'Session/day deducted successfully for member.'}), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/update_member_info', methods=['POST'])
def update_member_info():
    """API endpoint to update member information."""
    try:
        data = request.get_json()
        member_id = data.get('member_id')
        new_email = data.get('new_email')
        new_phone = data.get('new_phone')

        if not member_id or not new_email or not new_phone:
            return jsonify({'error': 'Member ID, new email, and new phone are required.'}), 400

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "EXEC [dbo].[UpdateMemberInfo] @Member_ID = ?, @New_Email = ?, @New_Phone = ?",
            member_id, new_email, new_phone
        )
        conn.commit()

        return jsonify({'message': 'Member information updated successfully.'}), 200

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@app.route('/api/calculate_gym_profit', methods=['GET'])
def calculate_gym_profit():
    """API endpoint to calculate the gym's profit."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT [dbo].[CalculateGymProfit]() AS GymProfit")
        result = cursor.fetchone()

        if result:
            return jsonify({'gym_profit': result[0]}), 200
        else:
            return jsonify({'error': 'Could not calculate gym profit.'}), 500

    except pyodbc.Error as e:
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()


if __name__ == '__main__':
    app.run(debug=True)
