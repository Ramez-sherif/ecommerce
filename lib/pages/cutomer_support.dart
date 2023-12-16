import 'package:flutter/material.dart';

class CustomerSupportForm extends StatefulWidget {
  const CustomerSupportForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomerSupportFormState createState() => _CustomerSupportFormState();
}

class _CustomerSupportFormState extends State<CustomerSupportForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> formData = {
    'name': '',
    'email': '',
    'subject': '',
    'message': '',
  };
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Customer Support',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Message'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitForm();
                  }
                },
                icon: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 67, 41, 154),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(Icons.send_rounded, color: Colors.white),
                ),
                label: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  alignment: Alignment.topLeft,
                  backgroundColor: Colors.green,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    String name = _nameController.text;
    String email = _emailController.text;
    String subject = _subjectController.text;
    String message = _messageController.text;

    formData['name'] = name;
    formData['email'] = email;
    formData['subject'] = subject;
    formData['message'] = message;
    // ignore: avoid_print
    print(formData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form submitted successfully'),
      ),
    );

    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
  }
}
