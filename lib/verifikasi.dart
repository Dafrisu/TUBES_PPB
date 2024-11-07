import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tubes_ppb/formGantiPassword.dart';
import 'package:tubes_ppb/login.dart';
import 'package:google_fonts/google_fonts.dart';

class verifikasi extends StatelessWidget {
  final String previousPage;
  const verifikasi({super.key, required this.previousPage});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kode Verifikasi'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: Color.fromARGB(255, 101, 136, 100),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Text(
                  'Untuk melindungi keamanan akun Anda, kami memerlukan kode verifikasi yang dikirimkan ke nomor Anda.',
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(fontSize: 18))),
              Padding(padding: EdgeInsets.only(bottom: 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: 68,
                      width: 64,
                      child: TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 101, 136, 100),
                                width: 3.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 101, 136, 100),
                                width: 3.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      )),
                  SizedBox(
                      height: 68,
                      width: 64,
                      child: TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 101, 136, 100),
                                width: 3.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 101, 136, 100),
                                width: 3.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      )),
                  SizedBox(
                      height: 68,
                      width: 64,
                      child: TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 101, 136, 100),
                                width: 3.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 101, 136, 100),
                                width: 3.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      )),
                  SizedBox(
                      height: 68,
                      width: 64,
                      child: TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 101, 136, 100),
                                width: 3.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 101, 136, 100),
                                width: 3.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 101, 136, 100),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1))),
                onPressed: () {
                  // Logika navigasi berdasarkan nilai previousPage
                  if (previousPage == 'masukkanEmail') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Formgantipassword()),
                    );
                  } else if (previousPage == 'register') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => login()),
                    );
                  }
                },
                child: const Text(
                  'Konfirmasi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
