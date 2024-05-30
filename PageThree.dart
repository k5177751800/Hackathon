import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences

class PageThree extends StatefulWidget {
  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  List<Map<String, String>> foodEntries = [];
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController foodController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();

  Color backgroundColor = Color.fromARGB(255, 88, 75, 75);
  Color tableHeaderColor = Colors.white;
  Color tableCellColor = Colors.white;
  @override
  void initState() {
    super.initState();
    loadData(); // Load data when the widget initializes
  }

 @override
  Widget build(BuildContext context) {
    int totalCalories = 0;
    foodEntries.forEach((entry) {
      totalCalories += int.tryParse(entry['calories'] ?? '0') ?? 0;
    });

    Map<String, int> caloriesByDate = {};
    foodEntries.forEach((entry) {
      String date = entry['date']!;
      int calories = int.tryParse(entry['calories'] ?? '0') ?? 0;
      caloriesByDate.update(date, (value) => value + calories, ifAbsent: () => calories);
    });

    Map<int, String> hashToDate = {};
    for (var entry in foodEntries) {
      String date = entry['date']!;
      hashToDate[date.hashCode] = date;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Tracker'),
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView( 
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DataTable(
  columnSpacing: 15, // Add spacing between columns
  columns: [
    DataColumn(label: Text('Date', style: TextStyle(color: tableHeaderColor))),
    DataColumn(label: Text('Time', style: TextStyle(color: tableHeaderColor))),
    DataColumn(label: Text('Food', style: TextStyle(color: tableHeaderColor))),
    DataColumn(label: Text('Calories', style: TextStyle(color: tableHeaderColor))),
    DataColumn(label: Text('Delete', style: TextStyle(color: tableHeaderColor))),
  ],
  rows: foodEntries.asMap().entries.map((entry) {
    final index = entry.key;
    final data = entry.value;
    return DataRow(cells: [
      DataCell(
        Text(data['date'] ?? '', style: TextStyle(color: tableCellColor), overflow: TextOverflow.ellipsis, maxLines: 2),
      ),
      DataCell(
        Text(data['time'] ?? '', style: TextStyle(color: tableCellColor), overflow: TextOverflow.ellipsis, maxLines: 2),
      ),
      DataCell(
        Text(data['food'] ?? '', style: TextStyle(color: tableCellColor), overflow: TextOverflow.ellipsis, maxLines: 2),
      ),
      DataCell(
        Text(data['calories'] ?? '', style: TextStyle(color: tableCellColor), overflow: TextOverflow.ellipsis, maxLines: 2),
      ),
      DataCell(
        IconButton(
          icon: Icon(Icons.delete, color: tableCellColor),
          onPressed: () {
            deleteEntry(index);
          },
        ),
      ),
    ]);
  }).toList(),
),

SizedBox(height: 20),
TextField(
  controller: dateController,
  style: TextStyle(color: Colors.white), // Set text color to white
  decoration: InputDecoration(
    labelText: 'Date',
    labelStyle: TextStyle(color: Colors.white), // Set label text color to white
    hintText: DateFormat('MM-dd-yyyy').format(DateTime.now()),
    hintStyle: TextStyle(color: Colors.white54), // Set hint text color to a lighter white
    enabledBorder: UnderlineInputBorder(      
      borderSide: BorderSide(color: Colors.white), // Set underline color when TextField is in focus
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // Set underline color when TextField is not in focus
    ),
  ),
),

              TextField(
  controller: timeController,
  style: TextStyle(color: Colors.white), // Set text color to white
  decoration: InputDecoration(
    labelText: 'Time',
    labelStyle: TextStyle(color: Colors.white), // Set label text color to white
    hintText: DateFormat('HH:mm').format(DateTime.now()),
    hintStyle: TextStyle(color: Colors.white54), // Set hint text color to a lighter white
    enabledBorder: UnderlineInputBorder(      
      borderSide: BorderSide(color: Colors.white), // Set underline color
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // Set underline color
    ),
  ),
),
TextField(
  controller: foodController,
  style: TextStyle(color: Colors.white), // Set text color to white
  decoration: InputDecoration(
    labelText: 'Food',
    labelStyle: TextStyle(color: Colors.white), // Set label text color to white
    enabledBorder: UnderlineInputBorder(      
      borderSide: BorderSide(color: Colors.white), // Set underline color
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // Set underline color
    ),
  ),
),
TextField(
  controller: caloriesController,
  style: TextStyle(color: Colors.white), // Set text color to white
  decoration: InputDecoration(
    labelText: 'Calories',
    labelStyle: TextStyle(color: Colors.white), // Set label text color to white
    enabledBorder: UnderlineInputBorder(      
      borderSide: BorderSide(color: Colors.white), // Set underline color
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white), // Set underline color
    ),
  ),
  keyboardType: TextInputType.number,
),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addFoodEntry,
                child: Text('Add Entry'),
              ),
              SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1.7,
                child: foodEntries.isNotEmpty
                    ? Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: BarChart(
                            BarChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                  showTitles: true,
                                  getTextStyles: (value) => TextStyle(color: Colors.black),
                                  getTitles: (value) {
                                    return hashToDate[value.toInt()] ?? ''; // Offset bars by using hashToDate map
                                  },
                                  margin: 8,
                                  reservedSize: 30, // Add extra space on both sides of the x-axis
                                ),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  getTextStyles: (value) => TextStyle(color: Colors.black),
                                  getTitles: (value) {
                                    if (value % 100 == 0) {
                                      return value.toInt().toString();
                                    }
                                    return '';
                                  },
                                  margin: 8,
                                ),
                              ),
                              borderData: FlBorderData(show: true),
                              barGroups: caloriesByDate.entries.map((entry) {
                                final x = entry.key.hashCode.toInt();
                                final y = entry.value.toDouble();
                                return BarChartGroupData(x: x.toInt(), barRods: [BarChartRodData(y: y, colors: [Colors.blue])]);
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey,
                        child: Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              ),


              SizedBox(height: 20),
              Text(
                'Total Calories: $totalCalories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load data from shared preferences
      foodEntries = prefs.getStringList('foodEntries')?.map((entry) => entry.split(','))?.map((entry) => {
            'date': entry[0],
            'time': entry[1],
            'food': entry[2],
            'calories': entry[3],
          })?.toList() ?? [];
    });
    print('Current data: $foodEntries');
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> data = foodEntries.map((entry) => entry.values.join(',')).toList();
    prefs.setStringList('foodEntries', data); // Save data to shared preferences
  }

  @override
  void dispose() {
    super.dispose();
    saveData(); // Save data when the widget is disposed
  }

  

  void addFoodEntry() {
    setState(() {
      final newEntry = {
        'date': dateController.text,
        'time': timeController.text,
        'food': foodController.text,
        'calories': caloriesController.text,
      };
      foodEntries.add(newEntry);

      dateController.clear();
      timeController.clear();
      foodController.clear();
      caloriesController.clear();

      saveData(); // Save the updated data to shared preferences
    });
  }

  void deleteEntry(int index) {
    setState(() {
      foodEntries.removeAt(index);
      saveData(); // Save the updated data to shared preferences
    });
  }
}