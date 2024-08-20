import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        title: const Text("Touch Cloud"),
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white
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
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.teal.withAlpha(30),
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
                          height: 250,
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

  String weatherMessage() {
    return "Tempo em $cityName:";
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
    "day 1": {},
    "day 2": {},
    "day 3": {},
  };

    setState(() {
      weather = weather;
    });

    print(weather);
  }
}
