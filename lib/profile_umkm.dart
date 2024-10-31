// // main.dart
// import 'package:flutter/material.dart'; // Import the DashboardPage

// class Dashboard extends StatelessWidget {
//   const Dashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();
//     return Scaffold(
//       // Navbar
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
//         title: const Text('Profil UMKM',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//         actions: <Widget>[
//           const SizedBox(width: 10),
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               // Handle search button press
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.person),
//             onPressed: () {
//               // Handle profile button press
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.mail),
//             onPressed: () {
//               // Handle inbox button press
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               // Handle notifications button press
//             },
//           ),
//         ],
//       ),

//       // Profile UMKM
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Profile picture
//               GestureDetector(
//                 onTap: () => _pickProfilePicture(),
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: _profilePicture != null
//                       ? FileImage(_profilePicture)
//                       : AssetImage('assets/images/default_profile.png'),
//                 ),
//               ),
//               SizedBox(height: 20),

//               // Name field
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please enter your name';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _name = value,
//               ),
//               SizedBox(height: 20),

//               // Email field
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => _email = value,
//               ),
//               SizedBox(height: 20),

//               // Save button
//               ElevatedButton(
//                 onPressed: () => _submitForm(),
//                 child: Text('Save'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
