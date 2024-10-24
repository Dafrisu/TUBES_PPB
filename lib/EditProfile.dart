import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Edit Profile'),
        backgroundColor: Colors.green[400],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWW0xcyFQPL6DIne-s-4nHzmBuIMCN12FioA&s',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 80,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green[400],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Asep Montir',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'asepmontir@gmail.com',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),
              _buildTextField('ID Pembeli', '109238'),
              _buildTextField('Nama Lengkap', 'Asep Lengkap'),
              _buildTextField('Nomor Telefon', '129384751782'),
              _buildTextField('Alamat', 'Jalan Boulevard'),
              _buildTextField('Username', 'AsepL'),
              _buildTextField('Email', 'AsepL@email.co.id'),
              _buildTextField('Kata Sandi', 'AsepLlonzz'),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Implement save button logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Simpan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        initialValue: initialValue,
      ),
    );
  }
}