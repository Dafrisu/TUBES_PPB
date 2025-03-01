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
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController profilePictureController;
  late String defaultImg =
      "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg";

  bool isLoading = true;
  String profilePictureUrl = '';
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    profilePictureController = TextEditingController();

    fetchUserData(widget.userId);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    profilePictureController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData(String id) async {
    try {
      final response = await http.get(
        Uri.parse('localhost/pembeli/$id'),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          fullNameController.text = userData['nama_lengkap'];
          emailController.text = userData['email'];
          phoneController.text = userData['nomor_telepon'];
          addressController.text = userData['alamat'];
          usernameController.text = userData['username'];
          passwordController.text = userData['password'];
          profilePictureUrl = userData['profileImg'] ?? ''; // Handle null case
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data pengguna');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateProfile(String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('localhost/pembeli/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui profil: ${response.body}');
    }
  }

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
                  _showUrlInputDialog();
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _showUrlInputDialog() {
    profilePictureController.text = profilePictureUrl;
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

  Future<String> createCustomDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final String customDirPath = '${directory.path}/ImagesTest';
    final Directory customDir = Directory(customDirPath);
    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }
    return customDir.path;
  }

  Future<String> _saveImageLocally(File imageFile) async {
    final String customDirPath = await createCustomDirectory();
    final String fileName =
        DateTime.now().millisecondsSinceEpoch.toString() + '.png';
    final String localPath = '$customDirPath/$fileName';
    final File localImage = await imageFile.copy(localPath);
    return localImage.path;
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
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _showChangeProfilePictureDialog,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipOval(
                            child: (profilePictureUrl.isEmpty)
                                ? Image.network(
                                    defaultImg, // Default image URL
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
                                            // File does not exist, show default image
                                            return Image.network(
                                              defaultImg, // Default image URL
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            );
                                          } else {
                                            // File exists, show the image
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
                                        imageUrl: profilePictureUrl,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.network(
                                          defaultImg, // Default image URL
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
                    _buildTextField(emailController, 'Email'),
                    const SizedBox(height: 16),
                    _buildTextField(phoneController, 'Nomor Telepon'),
                    const SizedBox(height: 16),
                    _buildTextField(addressController, 'Alamat'),
                    const SizedBox(height: 16),
                    _buildTextField(usernameController, 'Nama Pengguna'),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Kata Sandi',
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      obscureText: !isPasswordVisible,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 375),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final updatedData = {
                            'nama_lengkap': fullNameController.text,
                            'email': emailController.text,
                            'nomor_telepon': phoneController.text,
                            'alamat': addressController.text,
                            'username': usernameController.text,
                            'password': passwordController.text,
                            'profileImg': profilePictureUrl,
                          };
                          try {
                            await updateProfile(widget.userId, updatedData);
                            widget.onProfileUpdated();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Profil berhasil diperbarui!')),
                            );
                            Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Kesalahan: ${e.toString()}')),
                            );
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
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
