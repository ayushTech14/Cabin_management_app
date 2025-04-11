import sys
import json
import socket
from PyQt6.QtWidgets import QApplication, QWidget, QVBoxLayout, QPushButton, QLabel, QLineEdit

class RestroomApp(QWidget):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Restroom, Unit & Seatbelt Status")
        self.setGeometry(100, 100, 400, 600)

        # ✅ Store restroom, unit, and seatbelt statuses separately
        self.restroom_data = {
            "restroom1": "available",
            "restroom2": "available"
        }

        self.unit_status_data = {
            "status": ["empty", "empty", "empty", "empty"]  # 4 baggage units
        }
        
        self.seatbelt_data = {
            "seatbelt": ["unfastened", "unfastened", "unfastened", "unfastened"]  # 4 seats
        }

        self.layout = QVBoxLayout()

        # ✅ IP Address Input
        self.ip_label = QLabel("Enter Server IP:")
        self.ip_input = QLineEdit()
        self.ip_input.setPlaceholderText("e.g., 192.168.72.89")
        self.layout.addWidget(self.ip_label)
        self.layout.addWidget(self.ip_input)

        # ✅ Labels for restrooms
        self.label1 = QLabel(f"Restroom 1: {self.restroom_data['restroom1']}")
        self.label2 = QLabel(f"Restroom 2: {self.restroom_data['restroom2']}")
        self.layout.addWidget(self.label1)
        self.layout.addWidget(self.label2)

        # ✅ Buttons to toggle restroom status
        self.button1 = QPushButton("Toggle Restroom 1")
        self.button1.clicked.connect(lambda: self.toggle_status("restroom1", self.label1))
        self.layout.addWidget(self.button1)

        self.button2 = QPushButton("Toggle Restroom 2")
        self.button2.clicked.connect(lambda: self.toggle_status("restroom2", self.label2))
        self.layout.addWidget(self.button2)

        # ✅ Labels for units & seatbelts
        self.unit_labels = []
        self.seatbelt_labels = []
        for i in range(4):
            unit_label = QLabel(f"Unit {i+1}: {self.unit_status_data['status'][i]}")
            self.unit_labels.append(unit_label)
            self.layout.addWidget(unit_label)
            
            seatbelt_label = QLabel(f"Seatbelt {i+1}: {self.seatbelt_data['seatbelt'][i]}")
            self.seatbelt_labels.append(seatbelt_label)
            self.layout.addWidget(seatbelt_label)

        # ✅ Buttons to toggle unit status & seatbelt status
        self.unit_buttons = []
        self.seatbelt_buttons = []
        for i in range(4):
            unit_button = QPushButton(f"Toggle Unit {i+1}")
            unit_button.clicked.connect(lambda _, idx=i: self.toggle_unit_status(idx))
            self.unit_buttons.append(unit_button)
            self.layout.addWidget(unit_button)
            
            seatbelt_button = QPushButton(f"Toggle Seatbelt {i+1}")
            seatbelt_button.clicked.connect(lambda _, idx=i: self.toggle_seatbelt_status(idx))
            self.seatbelt_buttons.append(seatbelt_button)
            self.layout.addWidget(seatbelt_button)

        # ✅ Send Data Buttons
        self.send_restroom_button = QPushButton("Send Restroom Data")
        self.send_restroom_button.clicked.connect(lambda: self.send_data(self.restroom_data, 5000))
        self.layout.addWidget(self.send_restroom_button)

        self.send_units_button = QPushButton("Send Baggage Data")
        self.send_units_button.clicked.connect(lambda: self.send_data(self.unit_status_data, 5050))
        self.layout.addWidget(self.send_units_button)
        
        self.send_seatbelt_button = QPushButton("Send Seatbelt & Baggage Data")
        self.send_seatbelt_button.clicked.connect(self.send_seatbelt_data)
        self.layout.addWidget(self.send_seatbelt_button)

        self.setLayout(self.layout)

    def toggle_status(self, restroom, label):
        """Toggle restroom availability"""
        self.restroom_data[restroom] = "occupied" if self.restroom_data[restroom] == "available" else "available"
        label.setText(f"{restroom.capitalize()}: {self.restroom_data[restroom]}")

    def toggle_unit_status(self, index):
        """Toggle unit status between empty, half, full (exclude 'occupied')"""
        status_order = ["empty", "half", "full"]
        current_status = self.unit_status_data["status"][index]

        # Ensure the status is valid before cycling
        if current_status not in status_order:
            current_status = "empty"

        next_status = status_order[(status_order.index(current_status) + 1) % len(status_order)]
        self.unit_status_data["status"][index] = next_status
        self.unit_labels[index].setText(f"Unit {index+1}: {next_status}")

    def toggle_seatbelt_status(self, index):
        """Toggle seatbelt status and ensure unit status follows the intended logic"""
        if self.seatbelt_data["seatbelt"][index] == "unfastened":
            self.seatbelt_data["seatbelt"][index] = "fastened"
        else:
            self.seatbelt_data["seatbelt"][index] = "unfastened"

        # Update UI labels
        self.seatbelt_labels[index].setText(f"Seatbelt {index+1}: {self.seatbelt_data['seatbelt'][index]}")

    def send_data(self, data, port):
        """Send data to the specified port"""
        server_ip = self.ip_input.text().strip()

        if not server_ip:
            print("❌ Please enter a valid IP address.")
            return

        try:
            client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            client.connect((server_ip, port))

            json_data = json.dumps(data)
            client.sendall(json_data.encode('utf-8'))
            client.close()

            print(f"✅ Sent to {server_ip} (Port {port}): {json_data}")
        except Exception as e:
            print(f"❌ Error sending data to port {port}: {e}")

    def send_seatbelt_data(self):
        """Send seatbelt and baggage data in the correct JSON format"""
        server_ip = self.ip_input.text().strip()
        if not server_ip:
            print("❌ Please enter a valid IP address.")
            return

        # ✅ Correct JSON format for seatbelt & baggage unit data
        seat_data = {}
        for i in range(4):
            seat_key = f"seat{i+1}"
            seatbelt_key = f"seat{i+1}_belt"
            baggage_key = f"baggage{i+1}"  # Adding baggage status

            # Occupancy status based on baggage status
            seat_data[seat_key] = "occupied" if self.unit_status_data["status"][i] != "empty" else "not occupied"

            # Seatbelt status
            seat_data[seatbelt_key] = "buckled" if self.seatbelt_data["seatbelt"][i] == "fastened" else "not buckled"

            # Baggage unit status (empty, half, full)
            seat_data[baggage_key] = self.unit_status_data["status"][i]

        # ✅ Send JSON data to port 5100
        self.send_data(seat_data, 5100)

        print(f"✅ Seatbelt & Baggage data sent: {json.dumps(seat_data, indent=2)}")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = RestroomApp()
    window.show()
    sys.exit(app.exec())

