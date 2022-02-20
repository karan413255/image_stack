import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> images = <String>[
      "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
      "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
      "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
      "https://images.unsplash.com/photo-1473700216830-7e08d47f858e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
    ];

    List<Widget> widgets = [
      ...images.map<Widget>((img) => Image.network(
            img,
            fit: BoxFit.cover,
          ))
    ];

    List<ImageProvider> providers = [
      ...images.map<ImageProvider>((img) => NetworkImage(
            img,
          ))
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Stack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Spacer(flex: 1),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Images:"),
                    ImageStack(
                      imageList: images,
                      imageRadius: 45,
                      imageCount: 3,
                      imageBorderWidth: 3,
                      totalCount: 4,
                      backgroundColor: Colors.yellowAccent,
                      imageBorderColor: Colors.orangeAccent,
                      extraCountBorderColor: Colors.black,
                    ),
                  ],
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Widgets:"),
                    ImageStack.widgets(
                      children: widgets,
                      widgetRadius: 45,
                      widgetCount: 3,
                      widgetBorderWidth: 3,
                      totalCount: 4,
                      backgroundColor: Colors.deepOrange,
                      widgetBorderColor: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Providers:"),
                    ImageStack.providers(
                      providers: providers,
                      imageRadius: 45,
                      imageCount: 3,
                      imageBorderWidth: 3,
                      totalCount: 4,
                      backgroundColor: Colors.lime,
                      imageBorderColor: Colors.cyan,
                      extraCountBorderColor: Colors.black,
                    ),
                  ],
                ),
              ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
