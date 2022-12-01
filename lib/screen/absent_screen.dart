import 'dart:io';

import 'package:attendance_flutter/api/absent_service.dart';
import 'package:attendance_flutter/util/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/style_constant.dart';

class AbsentScreen extends StatefulWidget {
  const AbsentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AbsentScreen();
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _AbsentScreen extends State<AbsentScreen> {
  bool _isLoadingSubmit = false;

  String absentType = "";
  String imagePath = "";
  DateTime selectedDate = DateTime.now();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String jwt = "";
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      jwt = prefs.getString("access_token") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Buat Izin',
          style: GoogleFonts.inter(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          Text(
            'Tanggal izin',
            style: labelTextStyle,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.datetime,
            style: inputTextStyle,
            decoration: inputDecoration,
            controller: _dateController,
            focusNode: AlwaysDisabledFocusNode(),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2022),
                lastDate: DateTime(2050),
              ).then((value) {
                setState(() {
                  if (value != null) {
                    selectedDate = value;
                    _dateController.text =
                        "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
                  }
                });
              });
            },
          ),
          const SizedBox(height: 10),
          Text(
            'Jenis Izin',
            style: labelTextStyle,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField(
            items: [
              DropdownMenuItem<String>(
                value: "SICK",
                child: Text(
                  "Sakit",
                  style: GoogleFonts.inter(),
                ),
              ),
              DropdownMenuItem<String>(
                value: "LEAVE",
                child: Text(
                  "Izin",
                  style: GoogleFonts.inter(),
                ),
              )
            ],
            style: inputTextStyle,
            decoration: inputDecoration,
            onChanged: (value) {
              if (value != null) {
                absentType = value;
              }
            },
          ),
          const SizedBox(height: 10),
          Text(
            'Keterangan',
            style: labelTextStyle,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.text,
            style: inputTextStyle,
            decoration: inputDecoration,
            minLines: 4,
            maxLines: 4,
            controller: _descriptionController,
          ),
          const SizedBox(height: 10),
          Text(
            'Upload Bukti',
            style: labelTextStyle,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          imagePath != ""
              ? Container(
                  color: Colors.grey[100],
                  child: Image.file(
                    File(imagePath),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                )
              : Container(),
          const SizedBox(height: 5),
          OutlinedButton(
            onPressed: () {
              final ImagePicker picker = ImagePicker();
              picker.pickImage(source: ImageSource.gallery).then((image) {
                if (image != null) {
                  setState(() {
                    imagePath = image.path;
                  });
                }
              });
            },
            child: Text(
              imagePath != "" ? 'Ganti Foto' : 'Tambah Foto',
              style: GoogleFonts.inter(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: _isLoadingSubmit
                ? null
                : () {
                    List<String> errors = [];

                    if (_dateController.text == "") {
                      errors.add("Tanggal izin tidak boleh kosong.");
                    }

                    if (absentType == "") {
                      errors.add("Jenis Izin tidak boleh kosong.");
                    }

                    if (_descriptionController.text == "") {
                      errors.add("Keterangan tidak boleh kosong.");
                    }

                    if (imagePath == "") {
                      errors.add("Foto bukti tidak boleh kosong.");
                    }

                    if (errors.isNotEmpty) {
                      displayMessageDialog(context, errors[0]);
                    } else {
                      setState(() {
                        _isLoadingSubmit = true;
                      });
                      addAbsent(
                        jwt,
                        absentType,
                        _descriptionController.text,
                        _dateController.text,
                        imagePath,
                      ).then((response) {
                        if (response.isSuccess()) {
                          displayMessageDialog(
                            context,
                            response.getSuccess().toString(),
                            () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          displayMessageDialog(
                              context, response.getError().toString());
                        }
                        setState(() {
                          _isLoadingSubmit = false;
                        });
                      });
                    }
                  },
            child: _isLoadingSubmit
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    'Kirim',
                    style: GoogleFonts.inter(),
                  ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
