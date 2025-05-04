import 'package:fast_location_pj/screens/history_screen.dart';
import 'package:fast_location_pj/service/via_cep_service.dart';
import 'package:fast_location_pj/widgets/addres_card.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController cepController = TextEditingController();
  String endereco = '';
  List<String> historico = [];

  void buscarCep() async {
    try {
      Map<String, dynamic> dados = await ViaCepService.buscarEndereco(cepController.text);
      String novoEndereco = "${dados['logradouro']}, ${dados['complemento']}, ${dados['bairro']}, ${dados['uf']}";

      setState(() {
        endereco = novoEndereco;
        historico.insert(0, novoEndereco);
        if (historico.length > 3) historico.removeLast();
      });
    } catch (e) {
      setState(() {
        endereco = "CEP não encontrado.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta de CEP'),
      backgroundColor: Color.fromARGB(255, 13, 121, 88),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Digite o CEP'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: buscarCep, child: const Text('Buscar')),
            const SizedBox(height: 20),
            Text(endereco, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Últimos endereços pesquisados:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...historico.map((e) => AddressCard(endereco: e)).toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen())),
              child: const Text('Histórico'),
            ),
          ],
        ),
      ),
    );
  }
}