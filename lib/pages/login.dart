import 'dart:async';
import 'dart:convert';

import 'package:cliente/pages/RecuperaSenha.dart';
import 'package:cliente/pages/dados_basicos.dart';
import 'package:cliente/pages/home.dart';
import 'package:cliente/pages/registrar.dart';
import 'package:cliente/pages/stagger_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

bool load = true;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  bool _validate = false;
  TextEditingController _emailTextController = new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();
  bool hidePass = true;
  bool liga_circular = false;
  List usuario = [];
  TabController _tabController;
  int index_tab = 0;

  AnimationController _animationController;

  @override
  void initState() {
    super.initState;
    load = true;
    liga_circular = false;
    verifica_logado(); //verifica se houve login e esta armazenado na variavel de preferencias
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Stack(
          children: <Widget>[
            Container(
              height: height,
              width: width,
              color: Colors.white,
              // decoration: BoxDecoration(
              //   gradient: RadialGradient(
              //     center: Alignment.center,
              //     radius: .66,
              //     // begin: Alignment.bottomCenter,
              //     // end: Alignment(0.0, 0.6), // 10% of the width, so there are ten blinds.
              //     colors: [ Colors.white, Color.fromRGBO(43, 61, 50, 1)], // whitish to gray
              //     tileMode: TileMode.repeated, // repeats the gradient over the canvas
              //   ),
              // ),
            ),
            ClipRRect(              
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Background.png'),
                    fit: BoxFit.cover
                  )
                ),
                width: width * 1,
                height: height * 0.92,
              ),
            ),
            Positioned(
              top: 100,
              // left: (MediaQuery.of(context).size.width / 2) - (150 / 2),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 150.0,
                    ),
                  ],
                ),
              )
            ),
            Positioned(
              top: 380,
              // right: (MediaQuery.of(context).size.width / 2) - 115,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {
                        print('Cadastrar');
                        Route route = SlideLeftRoute(builder: (context) => Registrar());
                        Navigator.push(context, route);
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(43, 61, 50, 1), borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Cadastrar',
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StaggerAnimation(
              controller: _animationController.view,
              padding: EdgeInsets.fromLTRB(0.0, 450.0, 0.0, 8.0),
              text: "Entrar",
              color: Colors.white,
              colorCircular: Color(0xff72d0c3),//Colors.black,
              textColor: Colors.black,
              route: SlideLeftRoute(builder: (context) => HomePage1()),
              function: () {
                showGeneralDialog(
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionBuilder: (context, a1, a2, widget) {
                    final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;     
                    return Transform(
                      transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                      child: Opacity(
                        opacity: a1.value,
                        child: AlertDialog(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          title: Text('Login'),
                          content: SingleChildScrollView(
                            child: Container(
                              height: 230,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[350],
                                    blurRadius:
                                        20.0, // has the effect of softening the shadow
                                  )
                                ],
                              ),
                              child: Form(
                                  key: _formkey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(left: 6, right: 6),
                                        height: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10.0, top: 0, bottom: 0),
                                          child: Material(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Colors.grey.withOpacity(0.2),
                                            elevation: 0.0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5.0),
                                              child: ListTile(
                                                title: TextFormField(
                                                  controller: _emailTextController,
                                                  decoration: InputDecoration(
                                                      hintText: "Email",
                                                      icon: Icon(Icons.alternate_email),
                                                      border: InputBorder.none),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      Pattern pattern =
                                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                      RegExp regex = new RegExp(pattern);
                                                      if (!regex.hasMatch(value))
                                                        return 'Entre com um email válido';
                                                      else
                                                        return null;
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.only(left: 6, right: 6),
                                        height: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10.0, top: 0, bottom: 0),
                                          child: Material(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Colors.grey.withOpacity(0.2),
                                            elevation: 0.0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5.0),
                                              child: ListTile(
                                                title: TextFormField(
                                                  obscureText: true,
                                                  controller: _passwordTextController,
                                                  decoration: InputDecoration(
                                                      hintText: "Senha",
                                                      icon: Icon(Icons.alternate_email),
                                                      border: InputBorder.none),
                                                  validator: (value) {
                                                    if (value.isEmpty) {

                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10.0, top: 15, bottom: 15),
                                        child: FlatButton(
                                          onPressed: () async {                                            
                                            Navigator.of(context).pop();
                                            Future.delayed(Duration(milliseconds: 600), () async {
                                              _animationController.forward();
                                            });
                                            String valida = await getData(_emailTextController.text);
                                            if (valida != null) {    
                                              _animationController.reverse();                                        
                                              Future.delayed(Duration(seconds: 1), () {
                                                Toast.show(
                                                  "Login Inválido, ou erro de Conexão", context,
                                                  duration: Toast.LENGTH_LONG,
                                                  gravity: Toast.CENTER,
                                                  backgroundRadius: 0.0
                                                );                                             
                                              });                                              
                                            }
                                            else {
                                              await addStringToSF(_emailTextController.text); 
                                              setState(() {
                                                load = false;
                                              });
                                              // await Future.delayed(Duration(seconds: 2));
                                              // Route route = SlideLeftRoute(builder: (context) => HomePage1());
                                              // Navigator.push(context, route);
                                              
                                              // Route route = SlideLeftRoute(builder: (context) => HomePage1(id_sessao: usuario[0]['id'].toString()));
                                              // Navigator.push(context, route);
                                              // Future.delayed(Duration(seconds: 2), () {
                                              //   // armazena email para lembrar do login
                                              //   Navigator.of(context).push(new MaterialPageRoute(
                                              //     // aqui temos passagem de valores id cliente(sessao) de login para home
                                              //     builder: (context) => new HomePage1(), //id_sessao: usuario[0]['id'].toString()
                                              //     ),
                                              //   );
                                              // });
                                            }
                                          },
                                          child: Container(
                                            width: 220,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(43, 61, 50, 1), borderRadius: BorderRadius.circular(10)),
                                            child: Center(
                                              child: Text(
                                                'Login',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button
                                                    .copyWith(color: Colors.white, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ),
                          ),
                          actionsPadding: EdgeInsets.symmetric(horizontal: 20),
                          // actions: [
                          //   FlatButton(
                          //     onPressed: () {
                                // Navigator.of(context).pop();
                                // Future.delayed(Duration(milliseconds: 600), () {
                                //   _animationController.forward();
                                // });                                              
                          //     }, 
                          //     child: Text('Login')
                          //   ),
                          // ],
                        ),
                      ),
                    );
                  },
                  transitionDuration: Duration(milliseconds: 1100),
                  barrierDismissible: true,
                  barrierLabel: '',
                  context: context,
                  pageBuilder: (context, animation1, animation2) {}
                );
              }
            ),
            Positioned(
              top: 530,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          showGeneralDialog(
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionBuilder: (context, a1, a2, widget) {
                              final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;     
                              return Transform(
                                transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                child: Opacity(
                                  opacity: a1.value,
                                  child: AlertDialog(
                                    shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16.0)),
                                    title: Text('Recuperar Senha'),
                                    content: RecuperaSenha(),
                                    actionsPadding: EdgeInsets.symmetric(horizontal: 20),                                
                                  ),
                                ),
                              );
                            },
                            transitionDuration: Duration(milliseconds: 1100),
                            barrierDismissible: true,
                            barrierLabel: '',
                            context: context,
                            pageBuilder: (context, animation1, animation2) {}
                          );
                        },
                        child: Text(
                          "< Recuperar Senha >",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(1),
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 3.0,
                                color: Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  Future<String> getData(String newsType) async {
    //  print(await getValuesSF());
    //print(newsType);
    String link =
        Basicos.codifica("${Basicos.ip}/crud/?crud=consulta1.${newsType}");
    try {
      var res1 = await http
          .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
      var res = Basicos.decodifica(res1.body);
      //print(res);
      if (res1.body.length > 2) {
        if (res1.statusCode == 200) {
          //gerar criptografia senha terminar depois
          List list = json.decode(res).cast<Map<String, dynamic>>();
          usuario = list;
          //print(list);
          if (usuario.isNotEmpty) {
            Basicos.local_retirada_id =
                usuario[0]['local_retirada_id'].toString();
            //print(Basicos.local_retirada_id);
//            Basicos.empresa_id =
//            usuario[0]['empresa_id'].toString();

            if ((usuario[0]['email'].toString() == _emailTextController.text) &&
                (usuario[0]['senha'].toString() ==
                    _passwordTextController.text)) {
              return "confirmado";
            } else {
              return null;
            }
          } else
            return null;
        }
        // return list;
      }
    } on Exception catch (E) {
      showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text("Erro"),
              content: new Text("Falha na Conexão"),
              actions: <Widget>[
                new MaterialButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(context); // aciona fechar do alerta
                  },
                  child: new Text("Fechar"),
                )
              ],
            );
          });
    }
  }

  addStringToSF(String s) async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    prefs1.setString('email', s);
  }

//
  getValuesSF() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs1.getString('email') ?? '';
    //final myString = prefs.getString('my_string_key') ?? '';
    return stringValue;
  }
//
//  removeValues() async {
//    SharedPreferences prefs1 = await SharedPreferences.getInstance();
//    prefs1.remove('email');
//  }

  void verifica_logado() async {
    final email = await getValuesSF();
    if (email != '') {
      // print(email);
      String link =
          Basicos.codifica("${Basicos.ip}/crud/?crud=consulta1.${email}");
      try {
        var res1 = await http
            .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
        var res = Basicos.decodifica(res1.body);
        if (res1.body.length > 2) {
          if (res1.statusCode == 200) {
            //gera criptografia senha terminar depois
            List list = json.decode(res).cast<Map<String, dynamic>>();
            usuario = list;
            Basicos.empresa_id = usuario[0]['empresa_id'].toString();
            Basicos.local_retirada_id =
                usuario[0]['local_retirada_id'].toString();
            // print(Basicos.empresa_id );
          }
        }

        Navigator.of(context).push(new MaterialPageRoute(
          // aqui temos passagem de valores id cliente(sessao) de login para home
          builder: (context) =>
              new HomePage1(id_sessao: usuario[0]['id'].toString()),
        ));
      } on Exception catch (E) {
        showDialog(
            context: context,
            builder: (context) {
              return new AlertDialog(
                title: new Text("Erro"),
                content: new Text("Falha na Conexão"),
                actions: <Widget>[
                  new MaterialButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(context); // aciona fechar do alerta
                    },
                    child: new Text("Fechar"),
                  )
                ],
              );
            });
      }
    }
  }

// mostra circular indicator
  void circular(String tipo) {
    if (tipo == 'inicio') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Dialog(
                  child: new Container(
                color: Colors.black,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      'carregando',
                      style: new TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    new CircularProgressIndicator(),
                    // new Text("Carrengando ..."),
                  ],
                ),
              )));
    } else
      Navigator.pop(context);
  }
}

//buildMaterialPassword(passwordTextController: _passwordTextController, hidePass: hidePass)
class buildMaterialPassword extends StatelessWidget {
  const buildMaterialPassword({
    Key key,
    @required TextEditingController passwordTextController,
    @required this.hidePass,
  })  : _passwordTextController = passwordTextController,
        super(key: key);

  final TextEditingController _passwordTextController;
  final bool hidePass;

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white.withOpacity(.8),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: ListTile(
            subtitle: TextFormField(
              controller: _passwordTextController,
              obscureText: hidePass,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Password",
                icon: Icon(Icons.lock_outline),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "O campo password não pode ficar vazio";
                } else if (value.length < 6) {
                  return "A senha tem que ter pelo menos 6 caracteres";
                }
                return null;
              },
            ),
            trailing: IconButton(
                icon: Icon(Icons.remove_red_eye),
                onPressed: () {
                  // setState(() {
                  //   hidePass = false;
                  // });
                }),
          ),
        ));
  }
}

//formLogin(formkey: _formkey, validate: _validate, emailTextController: _emailTextController)
class formLogin extends StatelessWidget {
  const formLogin({
    Key key,
    @required GlobalKey<FormState> formkey,
    @required bool validate,
    @required TextEditingController emailTextController,
  })  : _formkey = formkey,
        _validate = validate,
        _emailTextController = emailTextController,
        super(key: key);

  final GlobalKey<FormState> _formkey;
  final bool _validate;
  final TextEditingController _emailTextController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      autovalidate: _validate, //valida  a entrada do email
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white.withOpacity(.8),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: ListTile(
            subtitle: TextFormField(
                //autofocus: true,
                controller: _emailTextController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
                  icon: Icon(Icons.alternate_email),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Insira um endereço de email';
                  } else {
                    if (value.length < 3) {
                      return "Email Tem Que Ter Pelo Menos 3 Caracteres";
                    } else {
                      Pattern pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(value)) {
                        return 'Insira um endereço de email válido';
                      } else
                        return null;
                    }
                  }
                }),
          ),
        ),
      ),
    );
  }
}
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.blueAccent,
//         unselectedItemColor: Colors.white,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home,
//               color: Colors.white,
//             ),
//             title: Text(
//               "Início ",
//               style: TextStyle(color: Colors.white, fontSize: 12),
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.playlist_add_check,
//             ),
//             title: Text(
//               "Pedidos",
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.shopping_basket,
//             ),
//             title: Text(
//               "Cesta",
//             ),
//           ),
//         ],
//         currentIndex: index_tab,
//         selectedItemColor: Colors.deepOrange,
//         onTap: (index) {
//           setState(() {
//             switch (index) {
//               case 0:
//                 index_tab = 0;
// //                Basicos.offset = 0; // zera o ofset do banco
// //                Basicos.product_list =
// //                []; // zera o lista de produtos da pagina principal
// //                Basicos.pagina = 1;
//                 //Basicos.buscar_produto_home = ''; // limpa pesquisa
//                 Navigator.of(context).push(new MaterialPageRoute(
//                   // aqui temos passagem de valores id cliente(sessao) de login para home
//                   builder: (context) => new HomePage1(id_sessao: 0),
//                 ));
//                 break;
//               case 1:
//                 index_tab = 1;
//                 Basicos.offset = 0; // zera o ofset do banco
//                 Basicos.product_list =
//                     []; // zera o lista de produtos da pagina principal
//                 Basicos.pagina = 1;
//                 //Basicos.buscar_produto_home = ''; // limpa pesquisa
//                 Navigator.of(context).push(new MaterialPageRoute(
//                   // aqui temos passagem de valores id cliente(sessao) de login para home
//                   builder: (context) => new HomePage1(id_sessao: 0),
//                 ));

//                 break;
//               case 2:
//                 index_tab = 2;
//                 Basicos.offset = 0; // zera o ofset do banco
//                 Basicos.product_list =
//                     []; // zera o lista de produtos da pagina principal
//                 Basicos.pagina = 1;
//                 //Basicos.buscar_produto_home = ''; // limpa pesquisa
//                 Navigator.of(context).push(new MaterialPageRoute(
//                   // aqui temos passagem de valores id cliente(sessao) de login para home
//                   builder: (context) => new HomePage1(id_sessao: 0),
//                 ));
//                 break;
//             }
//           });
//         },
//       ),

// child: Material(
//     borderRadius: BorderRadius.circular(20.0),
//     color: Colors.blueAccent,
//     elevation: 0.0,
//     child: MaterialButton(
//       onPressed: () async {
//         if (_formkey.currentState.validate()) {
//           //print(_formkey.toString());
//           // valida formulario
//           // acesso ao banco de dados
//           circular('inicio'); // mostra circular indicator
//           String valida = await getData(_emailTextController.text);
//           circular('fim'); // apaga circular indicator
          // if (valida == null)
          //   Toast.show(
          //       "Login Inválido, ou erro de Conexão", context,
          //       duration: Toast.LENGTH_LONG,
          //       gravity: Toast.CENTER,
          //       backgroundRadius: 0.0);
          // else {
          //   await addStringToSF(_emailTextController
          //       .text); // armazena email para lembrar do login
          //   Navigator.of(context).push(new MaterialPageRoute(
          //     // aqui temos passagem de valores id cliente(sessao) de login para home
          //     builder: (context) => new HomePage1(
          //         id_sessao: usuario[0]['id'].toString()),
          //   ));
          // }
//         } else {}
//       },
//       minWidth: MediaQuery.of(context).size.width,
//       child: Text(
//         "Entrar",
//         textAlign: TextAlign.center,
//         style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 20.0),
//       ),
//     )),
