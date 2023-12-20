import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/providers/profile.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/widgets/profile/location.dart';
import 'package:ecommerce/widgets/profile/phone.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/pages/orders.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ignore: prefer_final_fields
  TextEditingController _newValueController = TextEditingController();

  Future getUserProfile() async {
    String userId = context.read<UserProvider>().user.uid;

    UserModel? user = context.read<ProfileProvider>().userProfile;

    if (user == null) {
      await context.read<ProfileProvider>().setUserProfile(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return buildBody(context);
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  SafeArea buildBody(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Personal Info"),

                _buildProfileItem(
                  "Username",
                  context.watch<ProfileProvider>().userProfile!.username,
                ),

                _buildProfileItem(
                  "Email",
                  context.watch<ProfileProvider>().userProfile!.email,
                ),

                _buildSectionDivider(),
                buildSubTitle("Phone Number"),
                const PhoneProfileWidget(),
                _buildSectionDivider(),
                buildSubTitle("Location"),
                const LocationProfileWidget(),
                // _buildProfileItemWithEditButtonLoc(
                //   "Location",
                //   context.watch<ProfileProvider>().userProfile!.location,
                // ),

                // _buildSectionDivider(),

                // _buildSectionTitle("Orders Tracking"),

                _buildFullWidthButton(
                  "Your Orders",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderPage()),
                    );
                  },
                ),

                // _buildSectionDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text buildSubTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSubTitle(label),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildProfileItemWithEditButtonLoc(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               label,
  //               style: const TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 16,
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 value =
  //                     context.watch<ProfileProvider>().userProfile!.location;
  //                 _showEditDialogLoc(value);
  //               },
  //               child: const Text("Edit"),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           value,
  //           style: const TextStyle(
  //             fontSize: 16,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _showEditDialogLoc(String value) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Edit location"),
  //         content: TextField(
  //           controller: _newValueController,
  //           decoration: const InputDecoration(
  //             hintText: "Enter new location",
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text("Cancel"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text("Save"),
  //             onPressed: () {
  //               setState(() {
  //                 context.watch<ProfileProvider>().userProfile!.location =
  //                     _newValueController.text;
  //                 value =
  //                     context.watch<ProfileProvider>().userProfile!.location;
  //               });
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _showEditDialog(String value) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Edit Phone Number"),
  //         content: TextField(
  //           controller: _newValueController,
  //           decoration: const InputDecoration(
  //             hintText: "Enter new phone number",
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text("Cancel"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text("Save"),
  //             onPressed: () {
  //               setState(() {
  //                 //save _newValueController.text in the var:number in the DB ,
  //                 //if there's no var called number create one for this document
  //                 context.read<ProfileProvider>().userProfile!.number =
  //                     _newValueController.text;
  //                 value = context.watch<ProfileProvider>().userProfile!.number;
  //               });
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildSectionDivider() {
    return Divider(
      color: Theme.of(context).colorScheme.secondary,
      thickness: 1,
      height: 16,
    );
  }

  Widget _buildFullWidthButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return states.contains(MaterialState.pressed)
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return states.contains(MaterialState.pressed)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary;
            },
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
