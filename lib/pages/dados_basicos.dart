import 'package:flutter/material.dart';
import 'dart:convert' show utf8, base64;


class Basicos  {
    static String  ip = "http://200.129.247.236:8000"; // variavel publica com anderline na frente private
    //static String  ip = "http://200.129.247.242"; // ip servidor de produção
    static String categoria_usada ='*';//categorias id
    static String categoria_usada_desc =' ';//categorias descricao
    static String empresa_id = '';
    static String local_retirada_id = ''; //identifica local de reitrada na tabela de cliente

    //-----------controle de produtos
    static int offset=0; // posiciona a tela de home na posição inicial apos rolagens
    static List product_list = []; // carrega o lista da tela de home e vi preenchendo com as rolagens
    static double pagina =1; // contas as paginas na rolagem do home

    // ------------controle de pedidos
    static List meus_pedidos = [];

    // armazena consulta de produtos temporariamente
    static String buscar_produto_home='';


    static codifica(String cod) {
        // codifica o string a ser enviado ao servidor
        var bytes_utf8 = utf8
            .encode(cod.substring(39, cod.length)); //converte carateres em inteiro
        var dados = base64.encode(bytes_utf8); // converte inteiros para base64
        String temp = dados.substring(0, 2);
        String temp2 = dados.substring(2, dados.length);
        dados = temp + 'l' + temp2;
        return cod.substring(0, 39) + dados; // envia os dados
    }

    static decodifica(String cod) {
        // decodifica base64 que vem do servidor
        //print(cod);
        String temp = cod.substring(0, 5); //
        String temp2 = cod.substring(6, cod.length);
        cod = temp + temp2;
        String dados =
        (utf8.decode(base64.decode(cod.substring(3, cod.length - 2))))
            .replaceAll('\'', '"');
        dados = dados.replaceAll('Decimal(',''); // remove esse tido de retorno Decimal("111.000")
        dados = dados.replaceAll(')', ''); // remove o ")"
        return dados;
    }
}
