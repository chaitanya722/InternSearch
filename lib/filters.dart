import 'package:flutter/material.dart';

class FiltersPage extends StatefulWidget {
  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  String? selectedProfile;
  String? selectedCity;
  late String selectedDuration;

  List<String> profileOptions = ['Data Science Intern', 'Administration Intern', 'Business Analytics Intern','Android App Development Intern','Product Management Intern','Brand Management Intern'];
  List<String> cityOptions = ['Delhi', 'Banga', 'Kera','Tarn Taran','Parbhani','Lucknow','Gurgaon'];
  List<String> durationOptions = ['1 Month', '2 Months', '3 Months','4 Months','5 Months','6 Months'];

  @override
  void initState() {
    super.initState();
    selectedDuration = durationOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Filters',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, {
                'profile': selectedProfile,
                'city': selectedCity,
                'duration': selectedDuration,
              });
            },
            child: Text(
              'Apply',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProfileSection(),
            SizedBox(height: 20),
            buildCitySection(),
            SizedBox(height: 20),
            buildDropdown('Duration', durationOptions, selectedDuration, (String? value) {
              setState(() {
                selectedDuration = value!;
              });
            }),
          ],
        ),
      ),
    );
  }
Widget buildProfileSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Profile',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
      SizedBox(height: 10),
      PopupMenuButton<String>(
        onSelected: (String value) {
          setState(() {
            selectedProfile = value;
          });
        },
        itemBuilder: (BuildContext context) {
          return profileOptions.map((String option) {
            return PopupMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.add, color: Colors.blue),
            SizedBox(width: 5),
            Text(
              'Add Profile',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      Visibility(
        visible: selectedProfile != null && selectedProfile!.isNotEmpty, // Only show container if profile is selected
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
                                  color:Colors.blue,

            border: Border.all(                      color:Colors.blue,
),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(selectedProfile ?? "",style: TextStyle(color: Colors.white),),
        ),
      ),
    ],
  );
}

Widget buildCitySection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'City',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
      SizedBox(height: 10),
      PopupMenuButton<String>(
        onSelected: (String value) {
          setState(() {
            selectedCity = value;
          });
        },
        itemBuilder: (BuildContext context) {
          return cityOptions.map((String option) {
            return PopupMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.add, color: Colors.blue),
            SizedBox(width: 5),
            Text(
              'Add City',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      Visibility(
        visible: selectedCity != null && selectedCity!.isNotEmpty, // Only show container if city is selected
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
                      color:Colors.blue,

            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(12),
          
          ),
          child: Text(selectedCity ?? "",style:TextStyle(color:Colors.white)),
        ),
      ),
    ],
  );
}



  Widget buildDropdown(String hintText, List<String> options, String value, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
        'Maximum Duration(In months)',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
         Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down),
            hint: Text(hintText),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
        ),
      ),],
     
    );
  }
}
