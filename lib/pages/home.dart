//import 'package:ecomerce/chat/chats.dart';
import 'package:flutter/material.dart';
import 'package:cliente/pages/dados_basicos.dart';
import 'package:cliente/pages/login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart';

// meus imports
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:ecomerce/components/products.dart';
//import 'package:ecomerce/pages/cart.dart';
//import 'package:ecomerce/pages/pedidos.dart';
//import 'package:ecomerce/pages/minhaConta.dart';

class HomePage1 extends StatefulWidget {
  var id_sessao;
  final busca;

  HomePage1({
    this.id_sessao,
    this.busca,
  }); // id_cliente da sessao
  @override
  void initState() {}

  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(); // snackbar

  // barra de aviso
  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 2),
    ));
  }

  TextEditingController _buscar = TextEditingController();

  // monta combo categoria
  String _categoryItemSelected = '♦ Categorias';
  List client_list = [
    {'email': 'null'},
    {'nome_razao_social': 'null'}
  ];

  List<String> _category_list = [
    '♦ Categorias',
  ]; // dados estaticos de categorias

  String qtd = ""; //quantidade de itens na cesta
  bool _mostrabadge = false;
  String qtd_chat = ""; //quantidade de msg no chat
  bool _chatbadge = false;
  List<String> _categoria_produtos = []; // dados produtos

  TabController _tabController;
  int index_tab = 0;

  @override
  initState() {
    _tabController = new TabController(length: 4, vsync: AnimatedListState());
    index_tab = 0;
    //inicializa categoria
    buscaCategorias().then((resultado) {
      setState(() {});
    });
    new Future.delayed(const Duration(seconds: 1)) //snackbar
        .then((_) => _showSnackBar('Carregando ...')); //snackbar
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // snackbar
      // monta barra inicial com nome do app e os icones de busca e cesta

      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blueAccent,
        //centerTitle: true,

        title: Container(
            margin: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(50, 225, 255, 255),
              borderRadius: BorderRadius.all(Radius.circular(22.0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    child: TextFormField(
                      onFieldSubmitted: _buscar_produto,
                      controller: _buscar,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Buscar", //+${widget.id_sessao}",
                        hintStyle: TextStyle(color: Colors.white),
                        icon: Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            )),

        actions: <Widget>[
          Badge(
            badgeContent: Text('${qtd}'),
            showBadge: _mostrabadge,
            animationType: BadgeAnimationType.fade,
            position: BadgePosition.topRight(top: 0.0, right: 0.0),
            //(top: 0.0,bottom: 0.0,right: 0.0,left: 0.0),
            child: new IconButton(
                icon: Icon(
                  Icons.shopping_basket,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (widget.id_sessao == 0) {
                    Basicos.offset = 0; // zera o ofset do banco
                    Basicos.product_list =
                        []; // zera o lista de produtos da pagina principal
                    Basicos.pagina = 1;
                    //Basicos.buscar_produto_home = ''; // limpa pesquisa
                    Navigator.of(context).push(new MaterialPageRoute(
                      // aqui temos passagem de valores id cliente(sessao) de login para home
                      builder: (context) => new Login(),
                    ));
                  } else {
                    // print(widget.id_sessao);
                    Basicos.pagina = 1;
                    Basicos.offset = 0;
                    Basicos.product_list = [];
                    /*Navigator.of(context).push(new MaterialPageRoute(
                      // aqui temos passagem de valores id cliente(sessao) de login para home
                      builder: (context) =>
                          Cart(id_sessao: widget.id_sessao),
                    ));*/
                  }
                }),
          ),
        ],
      ),

      // monta o menu lateral
      drawer: new Drawer(
          //lista de componentes do menu
          child: new ListView(
        children: <Widget>[
          //header cabecalho
          // dados do usuário e conta
          new UserAccountsDrawerHeader(
            accountName:
                Text('${client_list[0]['nome_razao_social'].toString()}'),
            accountEmail: Text('${client_list[0]['email'].toString()}'
                '\nLocal Retirada:${client_list[0]['nome']}'),
            currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ))),
            decoration: new BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
//        body
          // lista do menu lateral
          InkWell(
            onTap: () {},
            child: Container(
              height: 40,
              color: Colors.grey.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Negociação',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.withOpacity(1),
                    fontWeight: FontWeight.normal,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (widget.id_sessao == 0) {
                Basicos.offset = 0; // zera o ofset do banco
                Basicos.product_list =
                    []; // zera o lista de produtos da pagina principal
                Basicos.pagina = 1;
                //Basicos.buscar_produto_home = ''; // limpa pesquisa
                Navigator.of(context).push(new MaterialPageRoute(
                  // aqui temos passagem de valores id cliente(sessao) de login para home
                  builder: (context) => new Login(),
                ));
              } else {
                Basicos.offset = 0;
                Basicos.product_list = [];
                Basicos.meus_pedidos = [];
                index_tab = 1;
                //Basicos.buscar_produto_home = ''; // limpa pesquisa
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new ChatsPage(id_sessao: widget.id_sessao)));*/
              }
            }, //vai para tela de pedidos

            child: Container(
              height: 50,
              child: ListTile(
                title: Text('Chat'),
                leading: Column(
                  children: <Widget>[
                    Badge(
                      badgeContent: Text('${qtd_chat}'),
                      showBadge: _chatbadge,
                      animationType: BadgeAnimationType.fade,
                      position: BadgePosition.topRight(top: 0.0, right: 0.0),
                    ),
                    Icon(Icons.chat),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: 40,
              color: Colors.grey.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'RELATÓRIOS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.withOpacity(1),
                    fontWeight: FontWeight.normal,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (widget.id_sessao == 0) {
                Basicos.offset = 0; // zera o ofset do banco
                Basicos.product_list =
                    []; // zera o lista de produtos da pagina principal
                Basicos.pagina = 1;
                //Basicos.buscar_produto_home = ''; // limpa pesquisa
                Navigator.of(context).push(new MaterialPageRoute(
                  // aqui temos passagem de valores id cliente(sessao) de login para home
                  builder: (context) => new Login(),
                ));
              } else {
                Basicos.offset = 0;
                Basicos.product_list = [];
                Basicos.meus_pedidos = [];
                index_tab = 1;
                //Basicos.buscar_produto_home = ''; // limpa pesquisa
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new MeusPedidos(id_sessao: widget.id_sessao)));*/
              }
            }, //vai para tela de pedidos
            child: Container(
              height: 35,
              child: ListTile(
                title: Text('Meus Pedidos'),
                leading: Icon(Icons.list),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (widget.id_sessao == 0) {
                Basicos.offset = 0; // zera o ofset do banco
                Basicos.product_list =
                    []; // zera o lista de produtos da pagina principal
                Basicos.pagina = 1;
                //Basicos.buscar_produto_home = ''; // limpa pesquisa
                Navigator.of(context).push(new MaterialPageRoute(
                  // aqui temos passagem de valores id cliente(sessao) de login para home
                  builder: (context) => new Login(),
                ));
              } else {
                Basicos.pagina = 1;
                Basicos.offset = 0; // zera o ofset do banco
                Basicos.product_list =
                    []; // zera o lista de produtos da pagina principal
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new Cart(
                            id_sessao: widget
                                .id_sessao))); // vai para pagina da cesta de compras*/
              }
            },
            child: Container(
              height: 35,
              child: ListTile(
                title: Text('Cesta de Compras'),
                leading: Icon(
                  Icons.shopping_basket,
                  //color: Colors.blueAccent,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Favoritos'),
              leading: Icon(Icons.favorite),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: 40,
              color: Colors.grey.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'CONFIGURAÇÕES',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.withOpacity(1),
                    fontWeight: FontWeight.normal,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (widget.id_sessao == 0) {
                Basicos.offset = 0; // zera o ofset do banco
                Basicos.product_list =
                    []; // zera o lista de produtos da pagina principal
                Basicos.pagina = 1;
                //Basicos.buscar_produto_home = ''; // limpa pesquisa
                Navigator.of(context).push(new MaterialPageRoute(
                  // aqui temos passagem de valores id cliente(sessao) de login para home
                  builder: (context) => new Login(),
                ));
              } else {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new minhaConta(id_sessao: widget.id_sessao)));*/
              }
            },
            child: Container(
              height: 35,
              child: ListTile(
                title: Text('Minha Conta'),
                leading: Icon(Icons.person),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: 35,
              child: ListTile(
                title: Text('Geral'),
                leading: Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('Sobre'),
              leading: Icon(
                Icons.help,
                color: Colors.red.withOpacity(0.6),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: 40,
              color: Colors.grey.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'ENCERRAR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.withOpacity(1),
                    fontWeight: FontWeight.normal,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await removeValues(); //remove  cooke
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: ListTile(
              title: Text('Sair'),
              leading: Icon(Icons.subdirectory_arrow_left),
            ),
          ),
        ],
      )),
//monta tab bar embaixo

// lista das categorias
      body: new ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 4.0),
            // color: Colors.grey,
            //alignment: Alignment.topLeft,
            height: 40,
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(2, 0.0, 0.0, 0.0),
                  width: 190,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(50, 225, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(22.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 4.0, 2.0, 4.0),
                    child: Material(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(22.0),
                      // dropbox categoria=============
                      child: Center(
                        child: DropdownButton<String>(
                          items:
                              _category_list.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: new Text(
                                dropDownStringItem.substring(
                                    dropDownStringItem.indexOf('-', 0) + 1,
                                    dropDownStringItem.length),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 15.0,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String newValueSelected) {
                            setState(() {
                              if (newValueSelected == '♦ Categorias') {
                                Basicos.categoria_usada = '*';
                                Basicos.categoria_usada_desc = '';
                              } else {
                                Basicos.categoria_usada =
                                    newValueSelected.substring(
                                        0,
                                        newValueSelected.indexOf('-',
                                            0)); // retira o codigo ate o hifem das categorias
                                Basicos.categoria_usada_desc = newValueSelected;
                              }
                              this._categoryItemSelected = newValueSelected;
                            });
                            Basicos.pagina = 1;
                            Basicos.product_list = [];
                            Navigator.of(context).push(new MaterialPageRoute(
                              // aqui temos passagem de valores id cliente(sessao) de login para home
                              builder: (context) =>
                                  new HomePage1(id_sessao: widget.id_sessao),
                            ));
                          },
                          value: _categoryItemSelected,
                          //dropbox categoria===================
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: 160,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(50, 225, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(22.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14.0, 2.0, 2.0, 4.0),
                    child: Material(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(22.0),
                      // dropdow categira=============
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => Registrar()));
                          },
                          child: Text(
                            "♥  Ofertas ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          new Padding(
            padding: const EdgeInsets.all(2.0),
            child: new Text(
              'Produtos Recentes: ' + //' ${ MediaQuery.of(context).size.height}' +
                  Basicos.categoria_usada_desc.substring(
                      Basicos.categoria_usada_desc.indexOf('-', 0) + 1,
                      Basicos.categoria_usada_desc.length),
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
            ),
          ),
          // grid de produtos abaixo da lista de  categorias
// monta card com produtos da tela proncipal==============================================

          //circular('inicio'),

          Container(
            height: MediaQuery.of(context).size.height - 195, //490.0,

            child: Container(
            ), // importado do componente produtos
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Basicos.offset = 0; // zera o ofset do banco
          Basicos.product_list =
              []; // zera o lista de produtos da pagina principal
          Basicos.pagina = 1;
          Navigator.of(context).push(new MaterialPageRoute(
            // aqui temos passagem de valores id cliente(sessao) de login para home
            builder: (context) => new HomePage1(id_sessao: widget.id_sessao),
          ));
        },
        child: Icon(Icons.autorenew),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        //fixedColor: Colors.blueAccent,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueAccent,
        unselectedItemColor: Colors.black,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text(
              "Início ",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
              title: Text(
                "Mensagem ",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              icon:  Badge(
                badgeContent: Text('${qtd_chat}'),
                showBadge: _chatbadge,
                animationType: BadgeAnimationType.fade,
                position: BadgePosition.topRight(top: -15.0, right: -10.0),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                ),
              ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.playlist_add_check,
              color: Colors.white,
            ),
            title: Text(
              "Pedidos",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_basket,
              color: Colors.white,
            ),
            title: Text(
              "Cesta",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
        currentIndex: index_tab,
        selectedItemColor: Colors.deepOrange,
        onTap: (index) {
          setState(() {
            switch (index) {
              case 0:
                if (widget.id_sessao == '0') {
                  Basicos.offset = 0; // zera o ofset do banco
                  Basicos.product_list =
                      []; // zera o lista de produtos da pagina principal
                  Basicos.pagina = 1;
                  //Basicos.buscar_produto_home = ''; // limpa pesquisa
                  Navigator.of(context).push(new MaterialPageRoute(
                    // aqui temos passagem de valores id cliente(sessao) de login para home
                    builder: (context) => new HomePage1(id_sessao: '0'),
                  ));
                } else {
                  index_tab = 0;
                  Basicos.offset = 0; // zera o ofset do banco
                  Basicos.product_list =
                      []; // zera o lista de produtos da pagina principal
                  Basicos.pagina = 1;
                  //Basicos.buscar_produto_home = ''; // limpa pesquisa
                  Navigator.of(context).push(new MaterialPageRoute(
                    // aqui temos passagem de valores id cliente(sessao) de login para home

                    builder: (context) =>
                        new HomePage1(id_sessao: widget.id_sessao),
                  ));
                }
                break;
              case 1:
                if (widget.id_sessao == '0') {
                  Basicos.offset = 0; // zera o ofset do banco
                  Basicos.product_list =
                      []; // zera o lista de produtos da pagina principal
                  Basicos.pagina = 1;
                  //Basicos.buscar_produto_home = ''; // limpa pesquisa
                  Navigator.of(context).push(new MaterialPageRoute(
                    // aqui temos passagem de valores id cliente(sessao) de login para home
                    builder: (context) => new Login(),
                  ));
                } else {
                  index_tab = 0;
                  Basicos.offset = 0; // zera o ofset do banco
                  Basicos.product_list =
                      []; // zera o lista de produtos da pagina principal
                  Basicos.pagina = 1;
                  //Basicos.buscar_produto_home = ''; // limpa pesquisa
                  /*Navigator.of(context).push(new MaterialPageRoute(
                    // aqui temos passagem de valores id cliente(sessao) de login para home

                    builder: (context) =>
                        new ChatsPage(id_sessao: widget.id_sessao),
                  ));*/
                }
                break;
              case 2:
                if (widget.id_sessao == 0) {
                  Basicos.offset = 0; // zera o ofset do banco
                  Basicos.product_list =
                      []; // zera o lista de produtos da pagina principal
                  Basicos.pagina = 1;
                  //Basicos.buscar_produto_home = ''; // limpa pesquisa
                  Navigator.of(context).push(new MaterialPageRoute(
                    // aqui temos passagem de valores id cliente(sessao) de login para home
                    builder: (context) => new Login(),
                  ));
                } else {
                  Basicos.pagina = 1;
                  Basicos.offset = 0;
                  Basicos.product_list = [];
                  Basicos.meus_pedidos = [];
                  index_tab = 1;
                  //Basicos.buscar_produto_home = ''; // limpa pesquisa
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              new MeusPedidos(id_sessao: widget.id_sessao)));*/
                }
                break;
              case 3:
                if (widget.id_sessao == 0) {
                  Basicos.offset = 0; // zera o ofset do banco
                  Basicos.product_list =
                      []; // zera o lista de produtos da pagina principal
                  Basicos.pagina = 1;
                  //Basicos.buscar_produto_home = ''; // limpa pesquisa
                  Navigator.of(context).push(new MaterialPageRoute(
                    // aqui temos passagem de valores id cliente(sessao) de login para home
                    builder: (context) => new Login(),
                  ));
                } else {
                  Basicos.offset = 0; // zera o ofset do banco
                  Basicos.product_list =
                      []; // zera o lista de produtos da pagina principal
                  Basicos.pagina = 1;
                  index_tab = 2;
                  //Basicos.buscar_produto_home = ''; // limpa pesquisa
                 /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              new Cart(id_sessao: widget.id_sessao)));*/
                }
                break;
            }
          });
        },
      ),
    );
  }

// lista as categorias para preencher o combo
  Future<List> buscaCategorias() async {
    //print(widget.id_sessao);
    String link = Basicos.codifica("${Basicos.ip}/crud/?crud=consulta4.");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body);
    //print(res1.body);
    //print(res);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        var list = json.decode(res) as List;
        list = list.map<Categoria>((json) => Categoria.fromJSON(json)).toList();
        //print(list);
        for (var i = 0, len = list.length; i < len; i++) {
          _category_list
              .add(list[i].id.toString() + '-' + list[i].descricao.toString());
        }
        //print(_category_list);
//        final email = await getValuesSF();
//        //print(email);
//        if (email != '') {
//// recupera o id da sessao se conectado
//          String link2 =
//          Basicos.codifica("${Basicos.ip}/crud/?crud=consulta1.${email}");
//            var res3 = await http
//                .get(Uri.encodeFull(link2), headers: {"Accept": "application/json"});
//            var res2 = Basicos.decodifica(res3.body);
//            if (res3.body.length > 2) {
//              if (res3.statusCode == 200) {
//                //gera criptografia senha terminar depois
//                List list1 = json.decode(res2).cast<Map<String, dynamic>>();
//                //usuario = list;
//                Basicos.empresa_id = list1[0]['empresa_id'].toString();
//                Basicos.local_retirada_id =
//                    list1[0]['local_retirada_id'].toString();
//                // print(Basicos.empresa_id );
//                widget.id_sessao= list1[0]['id'].toString();
//                print(widget.id_sessao);
//              }
//            }
//
//        }

        //print(widget.id_sessao);

        if (widget.id_sessao == 0) {
          //print('111');
          client_list[0]['nome_razao_social'] = 'Convidado';
          client_list[0]['email'] = 'Convidado';
          client_list[0]['nome'] = 'Convidado';
        } else {
          await busca_cliente();
          await busca_qtd_carrinho();
          await busca_msg_chat();
        }
        return list;
      }
    }
  }

// busca nome e email do cliente
  Future<List> busca_cliente() async {
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consult16.${widget.id_sessao}");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body);
    //print(res);
    if (res1.body.length > 2) {
      if (res1.statusCode == 200) {
        var list = json.decode(res).cast<Map<String, dynamic>>();
        client_list = list;
        //print(client_list);
        return list;
      }
    }
  }

  // busca msg chat
  Future<String> busca_msg_chat() async {
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consult81.${widget.id_sessao}");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body); // print(res.body);
    // print(res);
    if (res1.body.length >= 1) {
      if (res1.statusCode == 200) {
        var list = json.decode(res).cast<Map<String, dynamic>>();
        qtd_chat = list[0]["count"].toString();
        //   print(qtd);
        if (qtd_chat.toString() == '0') {
          _chatbadge = false;
        } else {
          _chatbadge = true;
        }
        return qtd_chat;
      }
    }
  }

// busca qt itens na cesta
  Future<String> busca_qtd_carrinho() async {
    String link = Basicos.codifica(
        "${Basicos.ip}/crud/?crud=consult19.${widget.id_sessao}");
    var res1 = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    var res = Basicos.decodifica(res1.body); // print(res.body);
    // print(res);
    if (res1.body.length >= 1) {
      if (res1.statusCode == 200) {
        var list = json.decode(res).cast<Map<String, dynamic>>();
        qtd = list[0]["count"].toString();
        //   print(qtd);
        if (qtd.toString() == '0') {
          _mostrabadge = false;
        } else {
          _mostrabadge = true;
        }
        return qtd;
      }
    }
  }

  void _buscar_produto(String) {
    //print('buscar');
    Basicos.buscar_produto_home = _buscar.text;
    Basicos.offset = 0;
    Basicos.product_list = [];
    Navigator.of(context).push(new MaterialPageRoute(
      // aqui temos passagem de valores id cliente(sessao) de login para home
      builder: (context) => new HomePage1(id_sessao: widget.id_sessao),
    ));
  }
}

//addStringToSF(String s) async {
//  SharedPreferences prefs1 = await SharedPreferences.getInstance();
//  prefs1.setString('email', s);
//}
//
getValuesSF() async {
  SharedPreferences prefs1 = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs1.getString('email') ?? '';
  //final myString = prefs.getString('my_string_key') ?? '';
  return stringValue;
}

//
removeValues() async {
  SharedPreferences prefs1 = await SharedPreferences.getInstance();
  prefs1.remove('email');
}

class Categoria {
  int id;
  String descricao;

  Categoria({
    this.id,
    this.descricao,
  });

  factory Categoria.fromJSON(Map<String, dynamic> jsonMap) {
    return Categoria(id: jsonMap['id'], descricao: jsonMap['descricao']);
  }
}
