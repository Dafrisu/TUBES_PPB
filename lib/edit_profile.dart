import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfile extends StatefulWidget {
  final String userId;
  final Function onProfileUpdated;

  const EditProfile(
      {super.key, required this.userId, required this.onProfileUpdated});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Text editing controllers for profile fields
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController usernameController;
  late TextEditingController profilePictureController;

  // Text editing controllers specifically for the change password dialog
  late TextEditingController newPasswordController;
  late TextEditingController confirmNewPasswordController;

  // Default image URL for profile picture if none is set or available
  late String defaultImg =
      "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg";

  bool isLoading = true; // State to manage loading of user data
  String profilePictureUrl = ''; // Stores the URL/path of the user's profile picture

  // Store original fetched data to compare against during update
  Map<String, dynamic> _originalUserData = {};

  // Regex for password validation (at least 8 chars, 1 uppercase, 1 lowercase, 1 number, 1 special character)
  final RegExp passwordRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])(?=.{8,})');

  // Regex for email validation
  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  // Regex for username validation (3-20 characters, alphanumeric and underscore)
  final RegExp usernameRegex = RegExp(r"^[a-zA-Z0-9_]{3,20}$");

  // Global key for the password change form for validation
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  // Global key for the main profile edit form for validation
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize all TextEditingControllers
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    usernameController = TextEditingController();
    profilePictureController = TextEditingController();

    // Initialize controllers for the change password dialog
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();

    // Fetch user data when the widget initializes
    fetchUserData(widget.userId);
  }

  @override
  void dispose() {
    // Dispose all TextEditingControllers to prevent memory leaks
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    usernameController.dispose();
    profilePictureController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  /// Fetches user data from the API based on the provided user ID.
  /// Populates the text controllers with the retrieved data.
  Future<void> fetchUserData(String id) async {
    try {
      final response = await http.get(
        Uri.parse('https://umkmapi-production.up.railway.app/pembeli/$id'),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          // Store original data
          _originalUserData = Map<String, dynamic>.from(userData);

          // Populate controllers with fetched data
          fullNameController.text = userData['nama_lengkap'];
          emailController.text = userData['email'];
          phoneController.text = userData['nomor_telepon'];
          addressController.text = userData['alamat'];
          usernameController.text = userData['username'];
          profilePictureUrl = userData['profileImg'] ?? ''; // Handle null case for profile image
          isLoading = false; // Data loaded, hide loading indicator
        });
      } else {
        // Throw an exception if the API call was not successful
        throw Exception('Gagal memuat data pengguna: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $error')),
      );
    }
  }

  /// Checks if an email or username already exists in the database.
  /// Returns a map indicating if emailExists and usernameExists.
  Future<Map<String, bool>> checkUserExistence(
      String email, String username) async {
    try {
      final response = await http.post(
        Uri.parse('https://umkmapi-production.up.railway.app/checkPembeli'), // Your backend endpoint
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'username': username,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return {
          'emailExists': result['emailExists'] ?? false,
          'usernameExists': result['usernameExists'] ?? false,
        };
      } else {
        debugPrint('Error checking existence: ${response.body}');
        throw Exception('Failed to check existence: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception checking existence: $e');
      return {'emailExists': false, 'usernameExists': false};
    }
  }

  /// Updates the user's profile information (excluding password).
  /// Sends a PUT request to the API with the updated data.
  Future<void> updateProfile(String id, Map<String, dynamic> data) async {
    // Note: The example backend URL 'http://10.0.2.2/pembeli/$id' suggests a local development server.
    // Ensure this matches your actual backend's accessible URL.
    final response = await http.put(
      Uri.parse('https://umkmapi-production.up.railway.app/pembeli/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      // Try to parse the error message from the backend if it's a JSON response
      try {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal memperbarui profil');
      } catch (_) {
        throw Exception('Gagal memperbarui profil: ${response.body}');
      }
    }
  }

  /// Displays a dialog for changing the profile picture, offering options
  /// to take a photo, choose from gallery, or enter a URL.
  void _showChangeProfilePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Foto Profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Ambil Foto'),
                onTap: () async {
                  final pickedFile =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    final localPath =
                        await _saveImageLocally(File(pickedFile.path));
                    setState(() {
                      profilePictureUrl = localPath;
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    final localPath =
                        await _saveImageLocally(File(pickedFile.path));
                    setState(() {
                      profilePictureUrl = localPath;
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Masukkan URL'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showUrlInputDialog(); // Show a separate dialog for URL input
                },
              )
            ],
          ),
        );
      },
    );
  }

  /// Displays a dialog to allow the user to input a URL for their profile picture.
  void _showUrlInputDialog() {
    profilePictureController.text =
        profilePictureUrl; // Pre-fill with current URL
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Masukkan URL Foto'),
          content: TextField(
            controller: profilePictureController,
            decoration: const InputDecoration(
              labelText: 'URL Foto',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  profilePictureUrl = profilePictureController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  /// Creates a custom directory for storing local images if it doesn't exist.
  Future<String> createCustomDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final String customDirPath = '${directory.path}/ImagesTest';
    final Directory customDir = Directory(customDirPath);
    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }
    return customDir.path;
  }

  /// Saves an image file locally within the app's custom directory.
  Future<String> _saveImageLocally(File imageFile) async {
    final String customDirPath = await createCustomDirectory();
    final String fileName =
        DateTime.now().millisecondsSinceEpoch.toString() + '.png';
    final String localPath = '$customDirPath/$fileName';
    final File localImage = await imageFile.copy(localPath);
    return localImage.path;
  }

  /// Password validation function using regex
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tolong masukkan kata sandi Anda';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'Kata sandi harus memiliki minimal 8 karakter, termasuk satu huruf besar, satu huruf kecil, satu angka, dan satu karakter spesial (!@#\$%^&*()_+)';
    }
    return null;
  }

  /// Displays a dialog for the user to change their password.
  /// It prompts for new password and new password confirmation.
  void _showChangePasswordDialog() {
    // Clear the controllers every time the dialog is opened for a fresh start
    newPasswordController.clear();
    confirmNewPasswordController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Kata Sandi'),
          content: SingleChildScrollView(
            child: Form(
              key: _passwordFormKey, // Associate form key for validation
              child: Column(
                mainAxisSize: MainAxisSize.min, // Make the column as small as needed
                children: [
                  TextFormField( // Use TextFormField for validation
                    controller: newPasswordController,
                    obscureText: true, // Hide input for security
                    decoration: const InputDecoration(
                      labelText: 'Kata Sandi Baru',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validatePassword, // Apply regex validation
                  ),
                  const SizedBox(height: 16),
                  TextFormField( // Use TextFormField for validation
                    controller: confirmNewPasswordController,
                    obscureText: true, // Hide input for security
                    decoration: const InputDecoration(
                      labelText: 'Konfirmasi Kata Sandi Baru',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tolong konfirmasi kata sandi baru Anda';
                      } else if (value != newPasswordController.text) {
                        return 'Kata sandi baru tidak cocok!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(), // Close dialog on "Batal"
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (_passwordFormKey.currentState!.validate()) { // Validate the form
                  try {
                    // Prepare the data to send to the backend for password update
                    final passwordUpdateData = {
                      'new_password': newPasswordController.text, // Send plain new password
                    };

                    // Send the password update request to the same profile update endpoint
                    await updateProfile(widget.userId, passwordUpdateData);

                    // If successful, update UI and dismiss dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kata sandi berhasil diperbarui!')),
                    );
                    Navigator.of(context).pop(); // Close dialog

                  } catch (e) {
                    // Show error message from the backend
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal memperbarui kata sandi: ${e.toString()}')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC4D79D),
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFC4D79D),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form( // Wrap with Form
                  key: _profileFormKey, // Assign the key
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap:
                            _showChangeProfilePictureDialog, // Tap to change profile picture
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipOval(
                              child: (profilePictureUrl.isEmpty)
                                  ? Image.network(
                                      defaultImg, // Display default image if URL is empty
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : profilePictureUrl.startsWith('/')
                                      ? FutureBuilder<bool>(
                                          future:
                                              File(profilePictureUrl).exists(),
                                          builder: (context, fileSnapshot) {
                                            if (fileSnapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else if (fileSnapshot.hasError ||
                                                !fileSnapshot.data!) {
                                              // Fallback to default if local file doesn't exist or error
                                              return Image.network(
                                                defaultImg,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              );
                                            } else {
                                              // Display local image
                                              return Image.file(
                                                File(profilePictureUrl),
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              );
                                            }
                                          },
                                        )
                                      : CachedNetworkImage(
                                          imageUrl:
                                              profilePictureUrl, // Display network image
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Image.network(
                                            defaultImg,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: _showChangeProfilePictureDialog,
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(fullNameController, 'Nama Lengkap'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        emailController,
                        'Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong.';
                          } else if (!emailRegex.hasMatch(value)) {
                            return 'Masukkan alamat email yang valid.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(phoneController, 'Nomor Telepon'),
                      const SizedBox(height: 16),
                      _buildTextField(addressController, 'Alamat'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        usernameController,
                        'Nama Pengguna',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama pengguna tidak boleh kosong.';
                          } else if (!usernameRegex.hasMatch(value)) {
                            return 'Nama pengguna harus 3-20 karakter dan hanya boleh berisi huruf, angka, atau garis bawah.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Add a dedicated "Change Password" button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _showChangePasswordDialog, // Call the popup function
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .orange, // Distinct color for password change
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Ubah Kata Sandi'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Button to update other profile details (excluding password)
                      Container(
                        constraints: const BoxConstraints(maxWidth: 375),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validate all TextFormFields in the main form first
                            if (_profileFormKey.currentState!.validate()) {
                              final currentEmail = emailController.text;
                              final currentUsername = usernameController.text;

                              // Only check if email or username has changed compared to original data
                              bool emailChanged = currentEmail != (_originalUserData['email'] ?? '');
                              bool usernameChanged = currentUsername != (_originalUserData['username'] ?? '');

                              if (emailChanged || usernameChanged) {
                                final existenceResult = await checkUserExistence(
                                  currentEmail,
                                  currentUsername,
                                );

                                if (emailChanged && existenceResult['emailExists']!) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Email sudah terdaftar.')),
                                  );
                                  return; // Stop if email exists
                                }
                                if (usernameChanged && existenceResult['usernameExists']!) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Nama pengguna sudah terdaftar.')),
                                  );
                                  return; // Stop if username exists
                                }
                              }

                              // If validation and existence checks pass, proceed with update
                              final updatedData = {
                                'nama_lengkap': fullNameController.text,
                                'email': currentEmail, // Use validated email
                                'nomor_telepon': phoneController.text,
                                'alamat': addressController.text,
                                'username': currentUsername, // Use validated username
                                'profileImg': profilePictureUrl,
                                // IMPORTANT: Password is NOT included here as it's handled separately
                                // via the dedicated change password dialog which sends 'new_password'.
                              };
                              try {
                                await updateProfile(widget.userId, updatedData);
                                widget
                                    .onProfileUpdated(); // Notify parent widget of update
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Profil berhasil diperbarui!')),
                                );
                                // Consider if you want to pop the screen here, e.g., Navigator.of(context).pop();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Kesalahan: ${e.toString()}')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Perbarui Profil'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  /// Helper widget to create consistent text fields.
  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return TextFormField( // Changed from TextField to TextFormField
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator, // Apply the validator
    );
  }
}