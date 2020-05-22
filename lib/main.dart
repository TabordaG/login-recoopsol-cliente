import 'package:cliente/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';
// meus pacotes


void main() {
  
  debugPaintSizeEnabled = false; // mostra posi;'ao dos widgts no layout
SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
            fontFamily: "Poppins",
            
            textTheme: TextTheme(
              headline5: TextStyle(fontWeight: FontWeight.bold),
              button: TextStyle(fontWeight: FontWeight.bold),
              headline6: TextStyle(fontWeight: FontWeight.bold),
            )),
      debugShowCheckedModeBanner: false,
        //home: HomePage1() // função principal monta a pagina inicial
      //home: Login(),
 //   home:Splash(),
        home:new SplashScreen(
            seconds: 3,
            navigateAfterSeconds: Login(),

          //navigateAfterSeconds: new HomePage1(id_sessao: 0,),
            title: new Text('Bem Vindo !!',style: TextStyle(color: Colors.yellow,fontSize: 18),),
            // image: new Image.asset('images/ecovendas2.png'),
            backgroundColor: Colors.blueAccent,
            styleTextUnderTheLoader: new TextStyle(),
            photoSize: 100.0,
            loaderColor: Colors.transparent,
        )
        );
  }
}

