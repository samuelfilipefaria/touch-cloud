import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  // TextEditingController cityNameController = TextEditingController();
  String cityName = "";

  Map weather = {
    "temperature": "",
    "wind": "",
    "description": "",
  };

  Map forecast = {
    "day 1": {},
    "day 2": {},
    "day 3": {},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Touch Cloud"),
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SearchBarTheme(
                data: SearchBarThemeData(
                  backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(255, 255, 255, 1)),
                  overlayColor: MaterialStateProperty.all(const Color.fromRGBO(255, 255, 255, 1)),
                  surfaceTintColor: MaterialStateProperty.all(const Color.fromRGBO(255, 255, 255, 1)),
                  textStyle: MaterialStateProperty.all(const TextStyle(
                    color: Colors.black,
                  )),
                ),
                child: SearchBar(
                  // controller: cityNameController,
                  leading: const Icon(Icons.search),
                  onSubmitted: (value) {
                    fetchCityWeather(value);
                  },
                )
              ),

              Card(
                color: Colors.white,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.teal.withAlpha(30),
                  onDoubleTap:() {
                    if (weather["temperature"] != "") { _showMyDialog(); }
                  },
                  onTap:() async {
                    final String textToCopy = weatherMessage();
                    if (textToCopy.isNotEmpty && weather["temperature"] != "") {
                      try {
                        await Clipboard.setData(ClipboardData(text: textToCopy));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Not copied!')),
                        );
                      }
                    }
                  },
                  child: Builder(
                    builder: (context) {
                      if (weather["temperature"] == "") {
                        return const SizedBox(
                          width: 300,
                          height: 100,
                          child: Center(
                            child: Text("Type a city name in the search bar..."),
                          )
                        );
                      } else {
                        return SizedBox(
                          width: 400,
                          height: 400,
                          child: ListView(
                            padding: const EdgeInsets.all(8),
                            children: <Widget>[
                              Container(
                                height: 50,
                                margin: const EdgeInsets.only(bottom: 10),
                                  child: Center(child:
                                    Text(
                                      cityName.toUpperCase(),
                                      style: const TextStyle(fontSize: 40),
                                    )
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: Center(child:
                                  Text(
                                    'Temperature: ${weather["temperature"]}', style: const TextStyle(fontSize: 20),
                                  )
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: Center(child:
                                  Text(
                                    'Wind: ${weather["wind"]}', style: const TextStyle(fontSize: 20),
                                  )
                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: Center(child:
                                  Text(
                                    'Description: ${weather["description"]}', style: const TextStyle(fontSize: 20),
                                  )
                                ),
                              ),
                              const Chip(
                                iconTheme: IconThemeData(color: Colors.teal),
                                avatar: Icon(Icons.copy),
                                label: Text('One tab to copy the values'),
                              ),
                              const Chip(
                                iconTheme: IconThemeData(color: Colors.teal),
                                avatar: Icon(Icons.auto_graph),
                                label: Text('Two taps to see the forecast'),
                              ),
                            ],
                          )
                        );
                      }
                    }
                  )
                ),
              ),
            ],
          )
        )
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forecast for next 3 days in $cityName'),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: SizedBox(
            height: 300,
            width: 800,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text("Day 1"),
                  subtitle: Text("Temperature: ${forecast["day 1"]["temperature"]} | Wind: ${forecast["day 1"]["wind"]}"),
                ),
                ListTile(
                  title: const Text("Day 2"),
                  subtitle: Text("Temperature: ${forecast["day 2"]["temperature"]} | Wind: ${forecast["day 2"]["wind"]}"),
                ),
                ListTile(
                  title: const Text("Day 3"),
                  subtitle: Text("Temperature: ${forecast["day 3"]["temperature"]} | Wind: ${forecast["day 3"]["wind"]}"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(const Color.fromRGBO(255, 255, 255, 1)),
              ),
              child: const Text('Close', style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String weatherMessage() {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final timeFormatter = DateFormat('HH:mm:ss');

    final DateTime now = DateTime.now();
    final formattedDate = dateFormatter.format(now);
    final formattedTime = timeFormatter.format(now);

    return "Weather in $cityName ($formattedDate on $formattedTime) => Temperature: ${weather["temperature"]} | Wind: ${weather["wind"]} | Description: ${weather["description"]}";
  }

  void fetchCityWeather(cityToFind) async {
    cityName = cityToFind;

    var city = cityToFind.toString().toLowerCase().replaceAll(" ", "-");

    var apiUrl = Uri.parse("https://goweather.herokuapp.com/weather/$city");
    var response = await http.get(apiUrl);
    var result = jsonDecode(response.body);

    weather = {
      "temperature": result["temperature"],
      "wind": result["wind"],
      "description": result["description"],
    };

    forecast = {
      "day 1": result["forecast"][0],
      "day 2": result["forecast"][1],
      "day 3": result["forecast"][2],
    };

    setState(() {
      weather = weather;
    });
  }
}
