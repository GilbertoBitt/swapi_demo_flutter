import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'JsonObject/Film.dart';
import 'JsonObject/People.dart';
import 'JsonObject/Planet.dart';
import 'JsonObject/Specie.dart';
import 'JsonObject/Starship.dart';
import 'JsonObject/Vehicle.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Api Filter list Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _ExamplePageState createState() => new _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'Search Example' );
  Map<String, People> _saved = new Map<String, People>();

  _ExamplePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
      actions: <Widget>[
        new IconButton(icon: Icon(Icons.list), onPressed: (){
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => PeopleFavoriteDetail(peopleFav: _saved.values.toList())));
        })
      ],
    );
  }



  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['name'].toLowerCase().contains(
            _searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
        itemCount: names == null ? 0 : filteredNames.length,
        itemBuilder: (BuildContext context, int index) {
          People people = People.fromMap(filteredNames[index]);
          bool isAlreadyFav = _saved.containsKey(people.name);
          return new ListTile(
              title: Text(people.name,
                style: TextStyle(fontSize: 18.0)
              ),
              trailing:
              IconButton(
                icon: Icon(isAlreadyFav ? Icons.star : Icons.star_border),
                color:  isAlreadyFav ? Colors.amberAccent : Colors.black26,
                onPressed: () {
                  setState(() {
                    if (isAlreadyFav) {
                      _saved.remove(people.name);
                    } else {
                      _saved.putIfAbsent(people.name, () => people);
                    }
                  });
                }
              ),
              onTap: () =>
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => PeopleDetail(people: people)))
          );
        });
  }


  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text( 'Search Example' );
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getNames() async {
    final response = await dio.get('https://swapi.co/api/people');
    List tempList = new List();
    for (int i = 0; i < response.data['results'].length; i++) {
      tempList.add(response.data['results'][i]);
    }
    setState(() {
      names = tempList;
      names.shuffle();
      filteredNames = names;
    });
  }


}

class StarshipInfo extends StatefulWidget{
  final List<Starship> starships;

  const StarshipInfo({Key key, this.starships}) : super(key: key);

  @override
  StarshipInfoState createState() => new StarshipInfoState();

}

class StarshipInfoState extends State<StarshipInfo>{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.starships.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return ListTile(
          title: Text(widget.starships[index].name),
          subtitle: Text(widget.starships[index].model),
          trailing: Icon(Icons.navigate_next),
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (context) => StarshipDetail(starship: widget.starships[index]))),
        );
      },
    );
  }
}

class StarshipDetail extends StatefulWidget{
  final Starship starship;

  const StarshipDetail({Key key, this.starship}) : super(key: key);

  @override
  StarshipDetailState createState() => new StarshipDetailState();

}

class StarshipDetailState extends State<StarshipDetail>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.starship.name),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new RowItem(paramText: 'Name: ', paramValue: widget.starship.name),
              new RowItem(paramText: 'Model: ', paramValue: widget.starship.model),
              new RowItem(paramText: 'Manufacturer: ', paramValue: widget.starship.manufacturer),
              new RowItem(paramText: 'Cost in Credits: ', paramValue: widget.starship.costInCredits),
              new RowItem(paramText: 'Length: ', paramValue: widget.starship.length),
              new RowItem(paramText: 'Max atmosphering Speed: ', paramValue: widget.starship.maxAtmospheringSpeed),
              new RowItem(paramText: 'Crew: ', paramValue: widget.starship.crew),
              new RowItem(paramText: 'Passengers: ', paramValue: widget.starship.passengers),
              new RowItem(paramText: 'Cargo Capacity: ', paramValue: widget.starship.cargoCapacity),
              new RowItem(paramText: 'Consumables: ', paramValue: widget.starship.consumables),
              new RowItem(paramText: 'Hyperdriving Rating: ', paramValue: widget.starship.hyperdriveRating),
              new RowItem(paramText: 'MGLT: ', paramValue: widget.starship.mglt),
              new RowItem(paramText: 'Starship Class: ', paramValue: widget.starship.starshipClass),
            ]
        )
    );
  }
}

class VehicleInfo extends StatefulWidget{
  final List<Vehicle> vehicles;

  const VehicleInfo({Key key, this.vehicles}) : super(key: key);

  @override
  VehicleInfoInfoState createState() => new VehicleInfoInfoState();

}

class VehicleInfoInfoState extends State<VehicleInfo>{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.vehicles.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return ListTile(
          title: Text(widget.vehicles[index].name),
          subtitle: Text(widget.vehicles[index].model),
          trailing: Icon(Icons.navigate_next),
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (context) => VehicleDetail(vehicle: widget.vehicles[index]))),
        );
      },
    );
  }
}

class VehicleDetail extends StatefulWidget{
  final Vehicle vehicle;

  const VehicleDetail({Key key, this.vehicle}) : super(key: key);

  @override
  VehicleDetailState createState() => new VehicleDetailState();

}

class VehicleDetailState extends State<VehicleDetail>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.vehicle.name),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new RowItem(paramText: 'Name: ', paramValue: widget.vehicle.name),
              new RowItem(paramText: 'Model: ', paramValue: widget.vehicle.model),
              new RowItem(paramText: 'Manufacturer: ', paramValue: widget.vehicle.manufacturer),
              new RowItem(paramText: 'Cost in Credits: ', paramValue: widget.vehicle.costInCredits),
              new RowItem(paramText: 'Length: ', paramValue: widget.vehicle.length),
              new RowItem(paramText: 'Max Atmosphering Speed: ', paramValue: widget.vehicle.maxAtmospheringSpeed),
              new RowItem(paramText: 'Crew: ', paramValue: widget.vehicle.crew),
              new RowItem(paramText: 'Passengers: ', paramValue: widget.vehicle.passengers),
              new RowItem(paramText: 'Cargo Capacity: ', paramValue: widget.vehicle.cargoCapacity),
              new RowItem(paramText: 'Consumables: ', paramValue: widget.vehicle.consumables),
              new RowItem(paramText: 'Vehicle Class: ', paramValue: widget.vehicle.vehicleClass),
            ]
        )
    );
  }
}

class SpecieInfo extends StatefulWidget{
  final List<Specie> species;

  const SpecieInfo({Key key, this.species}) : super(key: key);

  @override
  SpecieInfoState createState() => new SpecieInfoState();

}

class SpecieInfoState extends State<SpecieInfo>{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.species.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return ListTile(
            title: Text(widget.species[index].name),
            subtitle: Text(widget.species[index].classification),
            trailing: Icon(Icons.navigate_next),
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (context) => SpecieDetail(specie: widget.species[index]))),
        );
      },
    );
  }
}

class SpecieDetail extends StatefulWidget{
  final Specie specie;

  const SpecieDetail({Key key, this.specie}) : super(key: key);

  @override
  SpecieDetailState createState() => new SpecieDetailState();

}

class SpecieDetailState extends State<SpecieDetail>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.specie.name),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new RowItem(paramText: 'Name: ', paramValue: widget.specie.name),
              new RowItem(paramText: 'Classification: ', paramValue: widget.specie.classification),
              new RowItem(paramText: 'Designation: ', paramValue: widget.specie.designation),
              new RowItem(paramText: 'Average Height: ', paramValue: widget.specie.averageHeight),
              new RowItem(paramText: 'Skin Colors: ', paramValue: widget.specie.skinColors),
              new RowItem(paramText: 'Hair Colors: ', paramValue: widget.specie.hairColors),
              new RowItem(paramText: 'Eye Colors: ', paramValue: widget.specie.eyeColors),
              new RowItem(paramText: 'Average Lifespan: ', paramValue: widget.specie.averageLifespan),
//              widget.specie.homeworld != null ? new RowItem(paramText: 'Homeworld: ', paramValue: widget.specie.homeworld ) : new RowItem(paramText: 'Homeworld: ', paramValue: 'n/a',),
              new RowItem(paramText: 'Language: ', paramValue: widget.specie.language),
            ]
        )
    );
  }
}

class FilmsInfo extends StatefulWidget{
  final List<Film> films;

  const FilmsInfo({Key key, this.films}) : super(key: key);

  @override
  FilmsInfoState createState() => new FilmsInfoState();

}

class FilmsInfoState extends State<FilmsInfo>{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.films.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return ListTile(
          title: Text(widget.films[index].title),
          subtitle: Text('Episode: ${widget.films[index].episodeId.toString()}'),
          trailing: Icon(Icons.navigate_next),
          onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (context) => FilmsDetail(film: widget.films[index]))),
        );
      },
    );
  }
}

class FilmsDetail extends StatefulWidget{
  final Film film;

  const FilmsDetail({Key key, this.film}) : super(key: key);

  @override
  FilmsDetailState createState() => new FilmsDetailState();

}

class FilmsDetailState extends State<FilmsDetail>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.film.title),
    ),
    body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new RowItem(paramText: 'Titulo: ', paramValue: widget.film.title),
          new RowItem(paramText: 'Episodio: ', paramValue: widget.film.episodeId.toString()),
          new RowItem(paramText: 'Director: ', paramValue: widget.film.director),
          new RowItem(paramText: 'Producer: ', paramValue: widget.film.producer),
          new RowItem(paramText: 'Release Date: ', paramValue: widget.film.releaseDate.toLocal().toString()),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(child: Text('Star Wars opening Crawl', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
              Center(child: Text(widget.film.openingCrawl, style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))),
            ],
          )
//          new RowItem(paramText: 'Star Wars opening Crawl: ', paramValue: widget.film.openingCrawl),
        ]
      )
    );
  }
}

class PlanetInfo extends StatefulWidget{
  final Planet planet;

  const PlanetInfo({Key key, this.planet}) : super(key: key);

  @override
  _PlanetInfoState createState() => new _PlanetInfoState();

}

class _PlanetInfoState extends State<PlanetInfo>{
  var dio = new Dio();

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new RowItem(paramText: 'Name: ', paramValue: widget.planet.name),
          new RowItem(paramText: 'Rotation Period: ',
              paramValue: widget.planet.rotationPeriod),
          new RowItem(
              paramText: 'Orbital Period: ', paramValue: widget.planet.orbitalPeriod),
          new RowItem(paramText: 'Diameter: ', paramValue: widget.planet.diameter),
          new RowItem(paramText: 'Climate: ', paramValue: widget.planet.climate),
          new RowItem(paramText: 'Gravity: ', paramValue: widget.planet.gravity),
          new RowItem(paramText: 'Terrain: ', paramValue: widget.planet.terrain),
          new RowItem(
              paramText: 'Surface Water: ', paramValue: widget.planet.surfaceWater),
          new RowItem(
              paramText: 'Population: ', paramValue: widget.planet.population),
        ]
    );
  }
}

class PeopleInfo extends StatefulWidget {
  final People people;

  const PeopleInfo({Key key, this.people}) : super(key: key);

  @override
  _PeopleInfoState createState() => new _PeopleInfoState();

}

class _PeopleInfoState extends State<PeopleInfo>{

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new RowItem(paramText: 'Name: ', paramValue: widget.people.name),
        new RowItem(paramText: 'Height: ', paramValue: widget.people.height),
        new RowItem(paramText: 'Mass: ', paramValue: widget.people.mass),
        new RowItem(paramText: 'Hair Color: ', paramValue: widget.people.hairColor),
        new RowItem(paramText: 'Skin Color: ', paramValue: widget.people.skinColor),
        new RowItem(paramText: 'Eye Color: ', paramValue: widget.people.eyeColor),
        new RowItem(paramText: 'Birthday: ', paramValue: widget.people.birthYear),
        new RowItem(paramText: 'Gender: ', paramValue: widget.people.gender.toString().replaceAll('Gender.', '')),
        new RowItem(paramText: 'Birthday: ', paramValue: widget.people.birthYear),
      ],
    );
  }
}

class RowItem extends StatelessWidget {
  final String paramText;
  final String paramValue;
  const RowItem({
    Key key,
    @required this.paramText,
    @required this.paramValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(padding: EdgeInsets.all(2),
          child: Row(children: <Widget>[
              Text(paramText, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text(paramValue, style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
            ],
          )
        ),
      ],
    );
  }
}

class PeopleDetail extends StatefulWidget {
  final People people;

  const PeopleDetail({Key key, this.people}) : super(key: key);

  @override
  _PeopleDetailState createState() => new _PeopleDetailState();

}

class _PeopleDetailState extends State<PeopleDetail>{
  final dio = new Dio();
  int _selectedIndex = 0;
  Planet homeworld;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle optionStyleIconsLabel = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[

    Container(
      child: Text('Loading information')
    ),
    Container(
        child: Text('Loading information')
    ),
    Text(
      'Index 2: Films',
      style: optionStyle,
    ),
    Text(
      'Index 3: Species',
      style: optionStyle,
    ),
    Text(
      'Index 4: Vehicles',
      style: optionStyle,
    ),
    Text(
      'Index 5: Starships',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Planet> _getHomeWorld(String homeworldURL) async {
    final response = await dio.get(homeworldURL);
    var responseHomeWorld = Planet.fromMap(response.data);
    return responseHomeWorld;
  }

  Widget HomeWorld(String homeworldURL)=> FutureBuilder<Planet>(
      future: _getHomeWorld(homeworldURL), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<Planet> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Loading..');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            return Container(
                padding: EdgeInsets.all(10.0),
                child: PlanetInfo(planet: snapshot.data),
            );
        }
        return null; // unreachable
      },
    );

  Future<Film> _getFilm(String url) async{
    final response = await dio.get(url);
    return Film.fromMap(response.data);
  }

  Future<List<Film>> _getFilms(List<String> films) async {
    var filmsInfo = new List<Film>();
    for(int i = 0; i < films.length; i++){
      filmsInfo.add(await _getFilm(films[i]));
    }
    return filmsInfo;
  }

  Widget FilmsWidget(List<String> filmsList) => FutureBuilder<List<Film>>(
      future: _getFilms(filmsList), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<List<Film>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Loading..');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            return Container(
              padding: EdgeInsets.all(10.0),
              child: FilmsInfo(films: snapshot.data.toList()),
            );
        }
        return null; // unreachable
      },
    );

  Future<Specie> _getSpecie(String url) async{
    final response = await dio.get(url);
    return Specie.fromMap(response.data);
  }

  Future<List<Specie>> _getSpecies(List<String> species) async {
    var speciesList = new List<Specie>();
    for(int i = 0; i < species.length; i++){
      speciesList.add(await _getSpecie(species[i]));
    }
    return speciesList;
  }

  Widget SpeciaWidget(List<String> species) => FutureBuilder<List<Specie>>(
    future: _getSpecies(species), // a previously-obtained Future<String> or null
    builder: (BuildContext context, AsyncSnapshot<List<Specie>> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return Text('Loading..');
        case ConnectionState.active:
        case ConnectionState.waiting:
          return Text('Awaiting result...');
        case ConnectionState.done:
          if (snapshot.hasError)
            return Text('Error: ${snapshot.error}');
          return Container(
            padding: EdgeInsets.all(10.0),
            child: SpecieInfo(species: snapshot.data),
          );
      }
      return null; // unreachable
    },
  );

  Future<Vehicle> _getVehicle(String url) async{
    final response = await dio.get(url);
    return Vehicle.fromMap(response.data);
  }

  Future<List<Vehicle>> _getVehicles(List<String> vehicles) async {
    var speciesList = new List<Vehicle>();
    for(int i = 0; i < vehicles.length; i++){
      speciesList.add(await _getVehicle(vehicles[i]));
    }
    return speciesList;
  }

  Widget _VehicleWidget(List<String> vehicles) => FutureBuilder<List<Vehicle>>(
    future: _getVehicles(vehicles), // a previously-obtained Future<String> or null
    builder: (BuildContext context, AsyncSnapshot<List<Vehicle>> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return Text('Loading..');
        case ConnectionState.active:
        case ConnectionState.waiting:
          return Text('Awaiting result...');
        case ConnectionState.done:
          if (snapshot.hasError)
            return Text('Error: ${snapshot.error}');
          return Container(
            padding: EdgeInsets.all(10.0),
            child: VehicleInfo(vehicles: snapshot.data),
          );
      }
      return null; // unreachable
    },
  );

  Future<Starship> _getStarship(String url) async{
    final response = await dio.get(url);
    return Starship.fromMap(response.data);
  }

  Future<List<Starship>> _getStarships(List<String> starships) async {
    var speciesList = new List<Starship>();
    for(int i = 0; i < starships.length; i++){
      speciesList.add(await _getStarship(starships[i]));
    }
    return speciesList;
  }

  Widget _StarshipWidget(List<String> starships) => FutureBuilder<List<Starship>>(
    future: _getStarships(starships), // a previously-obtained Future<String> or null
    builder: (BuildContext context, AsyncSnapshot<List<Starship>> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return Text('Loading..');
        case ConnectionState.active:
        case ConnectionState.waiting:
          return Text('Awaiting result...');
        case ConnectionState.done:
          if (snapshot.hasError)
            return Text('Error: ${snapshot.error}');
          return Container(
            padding: EdgeInsets.all(10.0),
            child: StarshipInfo(starships: snapshot.data),
          );
      }
      return null; // unreachable
    },
  );


  @override
  Widget build(BuildContext context) {
    _widgetOptions[0] = Container(
      padding: EdgeInsets.all(10.0),
      child: PeopleInfo(people: widget.people),
    );
    _widgetOptions[1] = HomeWorld(widget.people.homeworld);
    _widgetOptions[2] = FilmsWidget(widget.people.films);
    _widgetOptions[3] = SpeciaWidget(widget.people.species);
    _widgetOptions[4] = _VehicleWidget(widget.people.vehicles);
    _widgetOptions[5] = _StarshipWidget(widget.people.starships);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.people.name),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text('Profile', style: optionStyleIconsLabel),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Homeworld', style: optionStyleIconsLabel),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            title: Text('Films', style: optionStyleIconsLabel),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inclusive),
            title: Text('Species', style: optionStyleIconsLabel),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            title: Text('Vehicles', style: optionStyleIconsLabel),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplanemode_active),
            title: Text('Starships', style: optionStyleIconsLabel),
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black26,
        selectedItemColor: Colors.lightBlue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PeopleFavoriteDetail extends StatefulWidget {
  final List<People> peopleFav;

  const PeopleFavoriteDetail({Key key, this.peopleFav}) : super(key: key);

  @override
  PeopleFavoriteDetailState createState() => new PeopleFavoriteDetailState();

}

class PeopleFavoriteDetailState extends State<PeopleFavoriteDetail>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
          itemCount: widget.peopleFav.length,
          itemBuilder: (BuildContext context, int index) {
            People people = widget.peopleFav[index];
            return new ListTile(
                title: Text(people.name,
                    style: TextStyle(fontSize: 18.0)
                ),
                onTap: () =>
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => PeopleDetail(people: people)))
            );
          }),
    );
  }
}