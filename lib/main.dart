import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<String> countries = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Antigua dan Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia dan Herzegovina',
    'Botswana',
    'Brasil',
    'Brunei',
  ];

  late List<String> renderCountry;

  List<String> searchCountry({required String filter}) {
    if (filter.isNotEmpty) {
      return countries
          .where((term) => term.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } else {
      return countries.reversed.toList();
    }
  }

  void deleteSearch(String term) {
    countries.removeWhere((t) => t == term);
    renderCountry = searchCountry(filter: '');
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    renderCountry = searchCountry(filter: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FloatingSearchBar(
        title: const Text('Search a Country: A-B'),
        hint: 'Search...',
        debounceDelay: const Duration(milliseconds: 500),
        transition: CircularFloatingSearchBarTransition(),
        physics: const BouncingScrollPhysics(),
        margins: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        scrollPadding: const EdgeInsets.only(top: 0.0),
        builder: (context, transition) {
          return ClipRRect(
            child: Material(
                color: Colors.white,
                child: Builder(
                  builder: (context) {
                    if (controller.query.isEmpty) {
                      return Container(
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Start searching',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    } else if (renderCountry.isEmpty) {
                      return ListTile(
                        title: Text(controller.query),
                        leading: const Icon(Icons.search),
                        onTap: () {
                          setState(() {});
                        },
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: renderCountry
                            .map(
                              (term) => ListTile(
                                title: Text(
                                  term,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: const Icon(Icons.history),
                                trailing: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      deleteSearch(term);
                                    });
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    controller.close();
                                  });
                                },
                              ),
                            )
                            .toList(),
                      );
                    }
                  },
                )),
          );
        },
        actions: [FloatingSearchBarAction.searchToClear()],
        controller: controller,
        onQueryChanged: (query) => setState(() {
          renderCountry = searchCountry(filter: query);
        }),
      ),
    );
  }
}
